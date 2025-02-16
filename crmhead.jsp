<%-- 
    Document   : crmhead
    Created on : May 17, 2019, 5:45:38 PM
    Author     : Akash
--%>
<%@page import="bioas.master.db.Employee"%>
<%@page import="java.util.Iterator"%>

<%-- Added  12.01.2019  --%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.ParseException"%>
<%@page import="bioas.util.DateValidate"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Set"%>
<%@page import="bioas.util.DeviceStatus"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="bioas.util.GenConstants"%>
<%@page isELIgnored = "false"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/jsp/com/formHeader.jsp"%>
<%@page session="true" errorPage="/jsp/excep/errorPage.jsp" isErrorPage="false"%>
<!doctype html>

<%    
    String cmpCD= usrLoginDetails.getCmpMst().getCmpCd();
    // Add 12.01.2019
    String String_OfficeID = usrLoginDetails.getOffMst().getId().getOffCd();
    String validAttDt = "0";
    SimpleDateFormat format2 = new SimpleDateFormat("dd-MMMM-yyyy");
    String strSysDt = format2.format(new Date());
    // end 
    String typeL = (String) request.getParameter("type");
    typeL = (typeL == null) ? "" : typeL;
    System.out.println(typeL);

    String crmUserType = (String)usrLoginDetails.getCrmUserType();
    
    System.out.println("UserType: " + crmUserType);
    boolean isPrEntryAllowed = crmUserType.equals("A") ? true : false; 
    boolean isPrSNOsRepAllowed = crmUserType.equals("S") ? false : true; //Added on 28.01.2020
    
    //Added below lines 20.10.2020
    String accInst = "";
    String accTotOrd = "";
    String accTodCnt = "";
    String accEnq = "";
    String toShow = "";
    if (crmUserType.equalsIgnoreCase("SE")) { 
        accInst = "inactiveLink";
        accTotOrd = "inactiveLink";
        accTodCnt = "inactiveLink";
        accEnq = "inactiveLink";
        toShow = "display: none;";
    }
    
    String toShowTargets = crmUserType.equals("S") ? "display: none;" : ""; //Added on 26.03.2021;

    //Added below on 24.09.2021
    String mngMod = "display: none;";
    if (crmUserType.equalsIgnoreCase("A")) {
        mngMod = "";
    }
    
%>

<nav class="navbar navbar-expand-md navbar-dark bg-dark sticky-top ">

    <button class="navbar-toggler mr-auto mb-2 bg-dark" type="button" data-toggle="collapse" data-target="#myNav">
        <span class="navbar-toggler-icon"></span>
    </button>
    <a href="#" class="nav-link ml-auto mb-2  mobileLogout" data-toggle="modal" data-target="#sign-out"><i class="fas fa-sign-out-alt text-danger  fa-lg"></i></a>
    <div class="collapse navbar-collapse" id="myNav">
        <div class="container-fluid">
            <div class="row">
                <div class="col-xl-2 col-lg-3 col-md-4  sidebar fixed-top">
                    <a href="#" class="navbar-brand text-white d-block mx-auto text-center py-3 mb-4 border-bottom"> 
                        <img src="<%=context%>/images/<%=cmpCD%>Logo.png" alt="Company Logo" style="height: 80px" class=" img-fluid">
                    </a>
                    <div class="border-bottom pb-3"><img src="<%=context%>/images/user.png" alt="User" class="rounded-circle img-fluid mr-3 usr">
                        <a href="#" class="text-white text-decoration-none"><%=String_UserName%></a>
                    </div>
                    <ul class="navbar-nav flex-column mt-4 opexcelSideNav">

                        <li class="nav-item"><a href="<%=context%>/Crm.do?operation=dashBoard" class="nav-link current text-white p-2 mb-2"><i class="fas fa-tachometer-alt text-light fa-lg mr-3"></i>Dashboard</a></li>

                        <%-- Added below lines on 14.02.2020 --%>
                        <li class="nav-item dropdown" style="<%= toShow %>" >
                            <a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#enquiry' >
                                <i class="fa fa-question text-light fa-lg mr-3"></i>Enquiries
                            </a>
                            <ul class="list-unstyled collapse " id="enquiry">
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getEEF"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Enquiry Entry</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getActEnq"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Active Enquiries</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getEnquiries"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Enquiries List</a></li>
                            </ul>
                        </li>
                        
                        <%-- Added below on 10.01.2022 --%>
                        <li class="nav-item dropdown" style="<%= toShow %>" >
                            <a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#tnd'>
                                <i class="fas fa-file-contract text-light fa-lg mr-3"></i>Tenders</a>
                            <ul class="list-unstyled collapse " id="tnd">
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getTEF"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> Tender Entry</a>
                                </li>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getTendersByApproval" class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right fa-sm mr-2"></i> Tender Approval</a></li> 
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getTenders&status=active" class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> Tender List</a></li> 
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getEMDEF" class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> EMD Entry</a></li> 
                                        <%-- commented lines no 129 to 131  And Added lines no 132 to 134 --%>
                                        <%--
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getEMDList" class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> EMD List</a></li>         --%>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getEmdReports" class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> EMD List</a></li>         
                            </ul>
                        </li>
                        <%-- Added above lines on 10.01.2022 --%>

                        
                        
                        <%-- Added below lines on 14.02.2020 --%>
                        <li class="nav-item dropdown "  ><a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#order' >
                        <i class="fa fa-shopping-bag text-light fa-lg mr-3"></i>Orders</a>
                            <ul class="list-unstyled collapse " id="order">
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getOEF"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Order Entry</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getPendOrds"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Pending Orders</a></li>
                                <li class="nav-item ml-5 py-1" style="<%= toShow %>"><a href="<%=context%>/Crm.do?operation=getOrders"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Orders List</a></li> <%-- Added on 21.12.2019 --%>
                                <li class="nav-item ml-5 py-1" style="<%= toShow %>"><a href="<%=context%>/Crm.do?operation=getBGEF"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> BG Entry</a></li> <%-- Added on 01.10.2020 --%>
                                <li class="nav-item ml-5 py-1" style="<%= toShow %>"><a href="<%=context%>/Crm.do?operation=getBGsList"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> BGs List</a></li> <%-- Added on 06.10.2020 --%>
                            </ul>
                        </li>
                        <%-- Added below lines on 17.09.2020 --%>
                        <li class="nav-item dropdown "  style="<%= toShow %>">
                            <a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#serv-contr' >
                            <i class="fa fa-cogs text-light fa-lg mr-3"></i>Service Contracts</a>
                            <ul class="list-unstyled collapse " id="serv-contr">
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getSCEF"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Service Contract Entry</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getPendContr"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Pending For Details</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getActContr"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Active Contracts</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getNonActContr"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Non-Active Contracts</a></li> <%-- Added on 08.03.2021 --%>
                            </ul>
                        </li>
                        <%-- Added below lines on 18.02.2021 --%>
                        <li class="nav-item dropdown "  style="<%= toShow %>">
                            <a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#serv-calls' >
                            <i class="fa fa-phone text-light fa-lg mr-3"></i>Service Calls</a>
                            <ul class="list-unstyled collapse " id="serv-calls">
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getServCallEF"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Service Call Entry/Update</a></li>
                                <%-- %>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getTicketEF"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Create Ticket</a></li>
                                <% Sample form --%>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getPendTickets"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Pending Tickets</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getTicketsList"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Tickets List</a></li>
                            </ul>
                        </li>
                        <%-- Added above lines on 18.02.2021 --%>
                        <%-- Added below lines on 20.07.2020 --%>
                        <li class="nav-item dropdown "  ><a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#p-order' >
                        <i class="fa fa-cart-arrow-down text-light fa-lg mr-3"></i>Purchases</a>
                            <ul class="list-unstyled collapse " id="p-order">
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getPOEF"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Purchase Order Entry</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getPendPOs"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Pending Purchase Orders</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getPOs"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Purchase Orders List</a></li> <%-- Added on 08.02.2021 --%>
                            </ul>
                        </li>
                        <%-- Added above lines on 01.04.2024 --%>
                        <li class="nav-item dropdown "  ><a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#rfq-mngt' >                       
                        <i class="fas fa-quote-left text-light fa-lg mr-3"></i>RFQ</a>
                            <ul class="list-unstyled collapse " id="rfq-mngt">
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getRFQEntr"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> RFQ Entry</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getRFQList"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> RFQ list</a></li>                                
                            </ul>
                        </li>
                        <%-- Added below lines on 19.08.2020 --%>
                        <li class="nav-item dropdown "  ><a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#m-rma' >
                        <i class="fa fa-recycle text-light fa-lg mr-3"></i>RMA</a>
                            <ul class="list-unstyled collapse " id="m-rma">
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getRmInEF"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> RMA Entry</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getActiveRMAs"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Pending Records</a></li> <%-- Added on 29.08.2020 --%>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getRMAStock"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Stock Report</a></li> <%-- Added on 06.04.2021 --%>
                            </ul>
                        </li>
                        <%-- Added above lines on 19.08.2020 --%>
                        <%-- Added below lines on 17.02.2020 --%>
                        <li class="nav-item dropdown " style="<%= toShow %>"><a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#customers' >
                        <i class="fa fa-user-circle text-light fa-lg mr-3 <%= accEnq %>"></i>Customers/Vendors</a>
                            <ul class="list-unstyled collapse " id="customers">
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getCustEntryFrm"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Create Customer</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getCustList"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Customers List</a></li>
                                <%-- Added below link on 30.06.2021 --%>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getCustDeclFrm"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Customer Declaration</a></li>
                            </ul>
                        </li>
                        <%-- Added above lines on 17.02.2020 --%>
                        <%-- Added below lines on 16.12.2019 --%>
                        <li class="nav-item dropdown "  ><a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#products' >
                        <i class="fab fa-product-hunt text-light fa-lg mr-3"></i>Products</a>
                            <ul class="list-unstyled collapse " id="products">
                                <% if (isPrEntryAllowed) { %>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getPrEntryFrm"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Create Product</a></li>
                                <% } %>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getPrList"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Products List</a></li>
                                <%-- Added below 2 links on 30.09.2020 --%>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getStockEF"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Stock Entry</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getStockRep"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Stock Report</a></li>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getStockSummaryRep"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Stock Summary Report</a></li> <%-- Added on 08.06.2021 --%>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getStockTF"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Stock Transfer Entry</a></li> <%-- Added on 26.10.2023 by Rabindra Sharma --%>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getStPending"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Stock Transfer Pending</a></li> <%-- Added on 28.10.2023 by Rabindra Sharma --%>
                                <li class="nav-item ml-5 py-1"><a href="<%=context%>/Crm.do?operation=getExcelDataUpload"  class=" sidebar-link  mb-2"><i class="fa fa-chevron-right  fa-sm mr-2"></i> Add Devices</a></li>
                            </ul>
                        </li>
                        <%-- Added above lines on 16.12.2019 --%>
                        <%-- Added below on 30.11.2019 --%>
                        <li class="nav-item dropdown">
                            <a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#rep'>
                                <i class="fa fa-clipboard-check text-light fa-lg mr-3"></i>Reports</a>
                            <ul class="list-unstyled collapse " id="rep">
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getPendPODs"  class="sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>Pending PODs</a></li>
                                <% if (isPrSNOsRepAllowed) { //Added on 28.01.2020 %>
				<li class="nav-item ml-5 py-1"> <%-- Added on 23.01.2020 --%>
				    <a href="<%=context%>/Crm.do?operation=getProdSNOs"  class="sidebar-link mb-2">
					<i class="fa fa-chevron-right fa-sm mr-2"></i>Products List for CRM
				    </a>
				</li>
                                <% } %>
                                <%-- Added below report on 09.07.2020 --%>
                                <li class="nav-item ml-5 py-1" style="<%= toShow %>">
                                    <a href="<%=context%>/Crm.do?operation=getPendRecv"  class="sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>Pending Receivables</a></li>
                                <%-- Added below report on 23.06.2021 --%>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getPendReturnable"  class="sidebar-link mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>Pending Returnable</a></li>
                                <%-- Added below report on 17.07.2020 --%>
                                <li class="nav-item ml-5 py-1" style="<%= toShow %>">
                                    <a href="<%=context%>/Crm.do?operation=getRectRep"  class="sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>Receipts Report</a></li>
                                <%-- Added below report on 03.11.2020 --%>
                                <li class="nav-item ml-5 py-1" style="<%= toShow %>">
                                    <a href="<%=context%>/Crm.do?operation=getBillableRep"  class="sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>Billable Report</a></li>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getGRNReport" class="sidebar-link mb-2">
                                        <i class="fa  fa-chevron-right fa-sm mr-2"></i>GRN Report
                                    </a>
                                </li>  
                            </ul>
                        </li>
                        <%-- Added above lines on 30.11.2019 --%>
                        <%-- Added below on 10.06.2019 --%>
                        <li class="nav-item dropdown">
                            <a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#doc'>
                                <i class="fa fa-file text-light fa-lg mr-3"></i>Documents</a>
                            <ul class="list-unstyled collapse " id="doc">
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getDocsUplFrm"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>Document Upload</a></li>
                                <%-- Added below link on 05.01.2022 --%>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getCompDocs" class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right fa-sm mr-2"></i>Company Documents for Download</a></li>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getUplDocsRep"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>Uploaded Documents Report</a></li>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getPackStickersFrm"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>Packing Stickers</a></li>
                                <%-- Added below link in 02.12.2020 --%>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=getExpVchrFrm"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>Expense Voucher</a></li>
                            </ul>
                        </li>
                        <%-- Added above lines on 10.06.2019 --%>
                        <%-- Added below lines on 22.03.2021 --%>
                        <li class="nav-item dropdown" style="<%= toShowTargets %>">
                            <a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#busTargets'>
                                <i class="fa fa-bullseye text-light fa-lg mr-3"></i>Targets</a>
                            <ul class="list-unstyled collapse " id="busTargets">
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=setTargets"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> Set Targets</a></li>
                            </ul>
                        </li>
                        <%-- Added above lines on 22.03.2021 --%>
                        <%-- Added below lines on 25.05.2020 --%>
                        <li class="nav-item dropdown" style="<%= mngMod %>">
                            <a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#office'>
                                <i class="fa fa-file text-light fa-lg mr-3"></i>Office Management</a>
                            <ul class="list-unstyled collapse " id="office">
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Master.do?operation=office&opxl=true"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> New Office</a></li>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Master.do?operation=modifyOffMaster&opxl=true"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> Edit Office</a></li>
                            </ul>
                        </li>
                        <li class="nav-item dropdown" style="<%= mngMod %>">
                            <a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#user'>
                                <i class="fa fa-file text-light fa-lg mr-3"></i>User Management</a>
                            <ul class="list-unstyled collapse " id="user">
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Master.do?operation=NewUserForm&opxl=true"  class=" sidebar-link  mb-2"> <%-- Added opxl=true on 30.06.2020 --%>
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> New User</a></li>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Master.do?operation=GetUserIdFrm&opxl=true"  class=" sidebar-link  mb-2"> <%-- Added opxl=true on 30.06.2020 --%>
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> Edit User</a></li>
<!--                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Master.do?operation=GetUserIdFrm&opxl=true"  class=" sidebar-link  mb-2"> <%-- Added opxl=true on 30.06.2020 --%>
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> Access Rights</a></li>-->
                            </ul>
                        </li>
                         <!-- Added by Akanksha on 31-05-2023 -->
                          <li class="nav-item dropdown" style="<%= mngMod %>">
                            <a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#challan'>
                                <i class="fa fa-file text-light fa-lg mr-3"></i>Delivery Challan</a>
                            <ul class="list-unstyled collapse " id="challan">
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=NewDCForm"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> New DC</a></li>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=PendDC"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> Pending DC</a></li>
                            </ul>
                         </li>
                         
                          <%-- Added by Rabindra Sharma on 25-01-2025 for Reminder Notification --%>
                          <li class="nav-item dropdown" style="<%= mngMod %>">
                            <a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#RemdNotify'>
                                <i class="fa fa-bell text-light fa-lg mr-3"></i>Reminder Notification</a>                               
                            <ul class="list-unstyled collapse " id="RemdNotify">
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=reminderEntry"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>
                                        New Reminder
                                    </a>
                                </li>                               
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=remReports"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>
                                        Reminder Reports
                                    </a>
                                </li>                               
                            </ul>
                         </li>
                         
                         
                        
                        <!-- Added by Rabindra Sharma on 07-04-2023 -->
                        
                        <li class="nav-item dropdown" style="<%= mngMod %>">
                            <a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#setting'>
                                <i class="fa fa-cog text-light fa-lg mr-3"></i>${GenConstants.settings}</a>
                            <ul class="list-unstyled collapse " id="setting">
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=confCourierListJson"  class=" sidebar-link  mb-2"> <%-- Added opxl=true on 30.06.2020 --%>
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>${GenConstants.COURIER_LIST_JSON}</a></li>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=confPCJson"  class=" sidebar-link  mb-2"> <%-- Added opxl=true on 30.06.2020 --%>
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>${GenConstants.PRODUCT_CATEGORY_JSON}</a></li>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=confIndianStatesJson"  class=" sidebar-link  mb-2"> <%-- Added opxl=true on 30.06.2020 --%>
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i>${GenConstants.INDIAN_STATES_JSON}</a></li>
                            </ul>
                        </li>
                        <%-- Added above lines on 25.05.2020 --%>
                        
                        <%-- below commented some line by Rabindra on 24-07-2023 --%>
                        <%-- <li class="nav-item dropdown" style="<%= mngMod %>">
                            <a href="#" class="nav-link sidebar-link text-white  mb-2 dropdown-toggle mainNavLink" data-toggle="collapse" data-target='#user'>
                                <i class="fa fa-file text-light fa-lg mr-3"></i>Delivery Challan</a>
                            <ul class="list-unstyled collapse " id="user">
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=NewDCForm"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> New DC</a></li>
                                <li class="nav-item ml-5 py-1">
                                    <a href="<%=context%>/Crm.do?operation=PendDC"  class=" sidebar-link  mb-2">
                                        <i class="fa fa-chevron-right  fa-sm mr-2"></i> Pending DC</a></li>
                            </ul>
                        </li>--%>
                        
                       <%-- <li class="nav-item"><a href="#" class="nav-link sidebar-link text-white p-3 mb-2"><i class="fa fa-shopping-cart text-light fa-lg mr-3"></i> Sales</a></li>
                        <li class="nav-item"><a href="#" class="nav-link sidebar-link text-white p-3 mb-2"><i class="fa fa-chart-line text-light fa-lg mr-3"></i> Analytics</a></li>
                        <li class="nav-item"><a href="#" class="nav-link sidebar-link text-white p-3 mb-2"><i class="fa fa-chart-bar text-light fa-lg mr-3"></i> Charts</a></li>
                        <li class="nav-item"><a href="#" class="nav-link sidebar-link text-white p-3 mb-2"><i class="fa fa-table text-light fa-lg mr-3"></i> Tables</a></li>
                        <li class="nav-item"><a href="#" class="nav-link sidebar-link text-white p-3 mb-2"><i class="fa fa-cogs text-light fa-lg mr-3"></i> Settings</a></li>--%>

                    </ul>
                      <div class="opexcelLogo mt-5">
                        <div style="width: 100%;bottom: 20px;background: black;margin: 0px;padding:0px;padding-top: 10px;">		    
                            <img src="images/ws_id1/opexcel.png" class="img-fluid w-100 ps-4" alt="Biometric Attendance System">
                        </div>
                    </div>
                     
                </div>
                <div class="col-xl-10 col-lg-9 col-md-8 ml-auto bg-dark fixed-top py-2 top-navbar">
                    <div class="row align-items-center desktop-nav">
                        <div class="col-md-8">
                            <!-- <h4 class="text-light text-uppercase mb-0">Dashboard</h4> -->
                            <h4 class="text-light text-uppercase mb-0 " ><a class=" text-light sideMenu" href="#"> <i class="navbar-toggler-icon text-light"></i></a> <%=String_CmpName.toUpperCase()%> </h4>
                        </div>
                        <div class="col-md-2">
                            <form class='d-none'>
                                <div class="input-group">
                                    <input type="text" class="form-control search-box">
                                    <button type="button" class="btn btn-light btn-search">
                                        <i class="fa fa-search text-danger "></i>
                                    </button>
                                </div>

                            </form>
                        </div>
                        <%-- Added below lines on 18.05.2020 --%>
                        <%-- %>
                        <div class="position-relative notificationIcon1 col-md-1" >
                            <a  href="#" class="notificationIcon"> <i class="far fa-bell"></i></a>
                            <div class="cursor alertIcon notificationIcon" id="notificationCount"></div>
                            <div class="notificationBox" >
                                <div class="card">
                                    <div class="card-header text-bold">
                                        Notification
                                    </div>
                                    <div id='MyNotification'>
                                    </div>
                               </div>
                            </div>                                 
                        </div>
                        <% Commented above on 25.05.2020 --%>
                        <%-- Added above lines on 18.05.2020 --%>
                        <%-- %>
                        <div class="col-md-1">
                            <ul class="navbar-nav">
                                <!-- <li class="nav-item icon-parent"> <a href="#" class="nav-link"><i class="fa fa-comments text-muted icon-bullet fa-lg"></i></a></li>
                                <li class="nav-item icon-parent"> <a href="#" class="nav-link"><i class="fa fa-bell icon-bullet text-muted fa-lg"></i></a></li> -->
                                <li class="nav-item  ml-md-auto "> <a href="#"  class="nav-link " data-toggle="modal" data-target="#sign-out"><i class="fas fa-sign-out-alt text-danger  fa-lg"></i></a></li>
                            </ul>
                        </div>
                        <% Commented above and modified as below on 25.05.2020 --%>
                        <div class="col-md-2">
                            <ul class="navbar-nav float-right">
                                 <li class="nav-item icon-parent dropdown"> 
                                    <a href="#" class="nav-link" id="dropdownMenuButton" data-toggle="dropdown"><i class="fa fa-bell icon-bullet text-muted fa-lg"></i></a>
                                    <div class="dropdown-menu dropdown-menu-right" style='min-width: 340px;' aria-labelledby="dropdownMenuButton">
                                       <div class="card1">
                                            <div class="card-header1 text-bold px-3">
                                                Notification
                                            </div>
                                            <hr/>
                                            <div id='MyNotification' class=''></div>
                                       </div>
                                    </div>				                                
                                </li>
                                <li class="nav-item  ml-md-auto "> <a href="#"  class="nav-link " data-toggle="modal" data-target="#sign-out"><i class="fas fa-sign-out-alt text-danger  fa-lg"></i></a></li>
                                <li class="nav-item  ml-md-auto "> <a href="#"  class="nav-link " data-toggle="modal" data-target="#changePswd"><i class="fas fa-key text-danger  fa-lg"></i></a></li>    
                            </ul>
                        </div>

                    </div>

                </div>
            </div>
        </div>

    </div>

</nav>
<div class="modal fade" id="sign-out">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">
                    Want to leave? </h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>

            </div>
            <div class="modal-body">
                Press logout to leave
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" data-dismiss="modal">Stay Here</button>
                <button type="button" onclick="doLogout();" class="btn btn-danger" data-dismiss="modal">Logout</button>
            </div>
        </div>
    </div>

</div>
<%-- Added below on 18.05.2020 --%>
<div class="modal fade bd-example-modal-xl" id="notificationModelBox" tabindex="-1" data-backdrop="static" >
  <div class="modal-dialog modal-dialog-scrollable  modal-xl" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalScrollableTitle">Visitor Details</h5>
        <button type="button" class="close closeModelBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="position-relative">
        <div class="modal-body notificationModelContent">

        </div>
        <div class="dbimg" id="visImg" align="center">
            <img src="<%= context %>/images/userImage.png" style="heigh:140px !important;width: 140px !important" />
        </div>
        </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary closeModelBox" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<%-- Added above on 18.05.2020 --%>
<%-- Added below on 26.04.2023 --%>
  <div class="modal fade" id="changePswd" data-backdrop="static">
        <div class="modal-dialog modal-dialog-centered modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">
                        Change Password</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <form id="change_pswd" class="form-horizontal">
                    <div class="modal-body">                                             
                        <div class="col-sm-12">
                            <!--<label>Current Password</label>-->
                            <input type="password" name="cr_pswd" autocomplete="off" id="cr_pswd" class="form-control form-control-sm" placeholder="Current Password"/>
                        </div>

                        <div class="col-sm-12">
                            <!--<label>New Password</label>-->
                            <input type="password" name="n_pswd" autocomplete="off" id="n_pswd" class="form-control form-control-sm" placeholder="New Password"/>
                            <i class="far fa-eye toggleClass" id="newPassword"></i>
                        </div>

                        <div class="col-sm-12">
                            <!--<label>Confirm Password</label>-->
                            <input type="password" autocomplete="off"  class="form-control form-control-sm"  name='cn_pswd' id='cn_pswd' placeholder="Confirm Password"/>
                            <i class="far fa-eye toggleClass" id="cnfPassword"></i>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button style="text-align:center" type="submit" class="btn btn-success btn-sm" >Submit</button>
                    </div>
                </form>
            </div>
        </div>
    </div>  
</html>