From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: 440SPE ADMA driver
Date: Wed, 6 May 2009 08:32:40 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C074F8F22@SDCEXCHANGE01.ad.amcc.com>
References: <491C68F3.3030102@emcraft.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1148640254=="
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@ozlabs.org>
Content-class: urn:content-classes:message
In-Reply-To: <491C68F3.3030102@emcraft.com>
List-Unsubscribe: <https://ozlabs.org/mailman/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Mime-version: 1.0
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@ozlabs.org
To: Ilya Yanok <yanok@emcraft.com>, Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, wd@denx.de, dzu@denx.de
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

--===============1148640254==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C9CE5F.E5C94204"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9CE5F.E5C94204
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi  Ilya,

  Are you going to push further in submitting the ADMA driver for 440SPE
?  If you are not I am planning to pursue this effort. I also have
couple later version of Soc's needed to submit.

Thank and Regards,

Marri

=20

From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ilya Yanok
Sent: Thursday, November 13, 2008 9:51 AM
To: Josh Boyer
Cc:; dzu@denx.de; wd@denx.de
Subject: Re: [PATCH 11/11] ppc440spe-adma: ADMA driver for PPC440SP(e)
systems

=20

This message has been archived. View the original item
<http://sdcmailvault.ad.amcc.com/EnterpriseVault/ViewMessage.asp?VaultId
=3D1E9560FDB597EB744B7F046F24F9462D91110000sdcmailvault.ad.amcc.com&Saves=
e
tId=3D705000000000000~200811131750430000~2~2007F01CF3764FBC926BAD4B10FE5B=
C
>=20

Josh Boyer wrote:
> On Thu, Nov 13, 2008 at 06:16:04PM +0300, Ilya Yanok wrote:
>  =20
>> Adds the platform device definitions and the architecture specific
support
>> routines for the ppc440spe adma driver.
>>
>> Any board equipped with PPC440SP(e) controller may utilize this
driver.
>>
>> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>> Signed-off-by: Ilya Yanok <yanok@emcraft.com>
>>    =20
>
> Before I really dig into reviewing this driver, I'm going to ask you
as simple
> question.  This looks like a 1/2 completed port of an arch/ppc driver
that uses
> the device tree (incorrectly) to get the interrupt resources and
that's about it.
> Otherwise, it's just a straight up platform device driver.  Is that
correct?
>  =20

Yep, that's correct.

> If that is the case, I think the driver needs more work before it can
be merged.
> It should get the DCR and MMIO resources from the device tree as well.
It should
> be binding on compatible properties and not based on device tree
paths.  And it
> should probably be an of_platform device driver.
>  =20

Surely, you're right. I agree with you in that this driver isn't ready
for merging. But it works so we'd like to publish it so interested
people could use it and test it.

Regards, Ilya.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


------_=_NextPart_001_01C9CE5F.E5C94204
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:Verdana;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman","serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
p
	{mso-style-priority:99;
	mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman","serif";}
span.EmailStyle18
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>Hi &nbsp;Ilya,<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>&nbsp; Are you going to push further in submitting the =
ADMA
driver for 440SPE ? &nbsp;If you are not I am planning to pursue this =
effort. I
also have couple later version of Soc&#8217;s needed to =
submit.<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>Thank and Regards,<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>Marri<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'><o:p>&nbsp;</o:p></span></p>

<div>

<div style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt =
0in 0in 0in'>

<p class=3DMsoNormal><b><span =
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'>From:</span>=
</b><span
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'>
linux-raid-owner@vger.kernel.org =
[mailto:linux-raid-owner@vger.kernel.org] <b>On
Behalf Of </b>Ilya Yanok<br>
<b>Sent:</b> Thursday, November 13, 2008 9:51 AM<br>
<b>To:</b> Josh Boyer<br>
<b>Cc:</b>; dzu@denx.de; wd@denx.de<br>
<b>Subject:</b> Re: [PATCH 11/11] ppc440spe-adma: ADMA driver for =
PPC440SP(e)
systems<o:p></o:p></span></p>

</div>

</div>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<div>

<p class=3DMsoNormal style=3D'background:lightblue'><b><span =
style=3D'font-size:10.0pt;
font-family:"Verdana","sans-serif"'>This message has been =
archived.&nbsp;<a
href=3D"http://sdcmailvault.ad.amcc.com/EnterpriseVault/ViewMessage.asp?V=
aultId=3D1E9560FDB597EB744B7F046F24F9462D91110000sdcmailvault.ad.amcc.com=
&amp;SavesetId=3D705000000000000~200811131750430000~2~2007F01CF3764FBC926=
BAD4B10FE5BC">View
the original item </a><o:p></o:p></span></b></p>

</div>

<div>

<p><span =
style=3D'font-size:10.0pt;font-family:"Verdana","sans-serif"'>Josh Boyer
wrote:<br>
&gt; On Thu, Nov 13, 2008 at 06:16:04PM +0300, Ilya Yanok wrote:<br>
&gt;&nbsp;&nbsp;&nbsp;<br>
&gt;&gt; Adds the platform device definitions and the architecture =
specific
support<br>
&gt;&gt; routines for the ppc440spe adma driver.<br>
&gt;&gt;<br>
&gt;&gt; Any board equipped with PPC440SP(e) controller may utilize this
driver.<br>
&gt;&gt;<br>
&gt;&gt; Signed-off-by: Yuri Tikhonov &lt;yur@emcraft.com&gt;<br>
&gt;&gt; Signed-off-by: Ilya Yanok &lt;yanok@emcraft.com&gt;<br>
&gt;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
&gt;<br>
&gt; Before I really dig into reviewing this driver, I'm going to ask =
you as
simple<br>
&gt; question.&nbsp;&nbsp;This looks like a 1/2 completed port of an =
arch/ppc
driver that uses<br>
&gt; the device tree (incorrectly) to get the interrupt resources and =
that's
about it.<br>
&gt; Otherwise, it's just a straight up platform device =
driver.&nbsp;&nbsp;Is
that correct?<br>
&gt;&nbsp;&nbsp;&nbsp;<br>
<br>
Yep, that's correct.<br>
<br>
&gt; If that is the case, I think the driver needs more work before it =
can be
merged.<br>
&gt; It should get the DCR and MMIO resources from the device tree as
well.&nbsp;&nbsp;It should<br>
&gt; be binding on compatible properties and not based on device tree
paths.&nbsp;&nbsp;And it<br>
&gt; should probably be an of_platform device driver.<br>
&gt;&nbsp;&nbsp;&nbsp;<br>
<br>
Surely, you're right. I agree with you in that this driver isn't =
ready<br>
for merging. But it works so we'd like to publish it so interested<br>
people could use it and test it.<br>
<br>
Regards, Ilya.<br>
<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe =
linux-raid&quot;
in<br>
the body of a message to majordomo@vger.kernel.org<br>
More majordomo info =
at&nbsp;&nbsp;http://vger.kernel.org/majordomo-info.html<o:p></o:p></span=
></p>

</div>

</div>

</body>

</html>

------_=_NextPart_001_01C9CE5F.E5C94204--

--===============1148640254==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@ozlabs.org
https://ozlabs.org/mailman/listinfo/linuxppc-dev
--===============1148640254==--
