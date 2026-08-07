Received: from out25-28.sg.a.dm.aliyun.com (out25-28.sg.a.dm.aliyun.com [8.219.25.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFC345C6E9
	for <linux-raid@vger.kernel.org>; Fri,  7 Aug 2026 21:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=8.219.25.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786139869; cv=none; b=Iipuxf1wimuVuD/FESS+JCEVmZeNIXgYLKpZtH+AyrBxQ3C3BOapoGlZ3FVKZ/qcDgw7jjOz+JgdaOGJskTUku+hgIv5JeccUbnpw/8dJp5zMRrtQx9uNywi6g8rljjwLgsXE3Kf1OwgM4dkcSDg35Ug7HaMa6GCekR6pD1Orv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786139869; c=relaxed/simple;
	bh=Xb+AI/tgOcvOF3qmA8QKJB8ShyfPfaTGZVEAS8hQ8vc=;
	h=Content-Type:MIME-Version:From:To:Subject:Date:Message-ID; b=OvLPlvhDLjw4o9TRocDRVtrJE73KZhXHts4oycEghqcx1SQNIcjLg/2hZU/VkNNR1ct9MyOc0KNeXBUW6mt04QHuwZ6Q8Zqo834JjeE+x42ZvZ8KMfvDkEhETjjFATv2ys7e/3dEWx00jsUxXHHSOR6htCh5DO+P+WZYJ06hJGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=materialdereparacionhogar.com.mx; spf=pass smtp.mailfrom=materialdereparacionhogar.com.mx; dkim=pass (1024-bit key) header.d=materialdereparacionhogar.com.mx header.i=@materialdereparacionhogar.com.mx header.b=pv761t54; arc=none smtp.client-ip=8.219.25.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=materialdereparacionhogar.com.mx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=materialdereparacionhogar.com.mx
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=materialdereparacionhogar.com.mx header.i=@materialdereparacionhogar.com.mx header.b="pv761t54"
X-AliDM-RcptTo: bGludXgtcmFpZEB2Z2VyLmtlcm5lbC5vcmc=
Feedback-ID: default:mark@materialdereparacionhogar.com.mx:alibabak_SmtpBatch:486392
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=materialdereparacionhogar.com.mx; s=aliyun-ap-southeast-1;
	t=1786139864; h=Content-Type:MIME-Version:From:To:Subject:Date:Message-ID;
	bh=Xb+AI/tgOcvOF3qmA8QKJB8ShyfPfaTGZVEAS8hQ8vc=;
	b=pv761t54FArX2KgemrY5+nnHUbB1S/wZ1dAOKk8seWK6/s0ejFW52Cgw5unaCf7KcF962aRNY8Fpg8ZCN4gQlCAbDKYEMLrYaaGeiBtZuvixJHSf3aCsrt3oCXXW3fToVLKj3HmJj32r633S7yr1XR0wfwUZySKW4Z0I9/z2O5I=
Received: from f802b3ce(mailfrom:mark@materialdereparacionhogar.com.mx fp:SMTPD_4w3hSFppYcL cluster:dm-ay35sg-a)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 08 Aug 2026 05:51:57 +0800
X-EnvId: 8000000305927703129
Content-Type: multipart/mixed; boundary="===============1223213285074523554=="
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "=?UTF-8?Q?internal-revenue-services.Reminder?="
 <mark@materialdereparacionhogar.com.mx>
To: linux-raid@vger.kernel.org
Subject: =?UTF-8?Q?Your document is ready?=
Date: Fri, 07 Aug 2026 21:51:53 -0000
Message-ID: 
 <178613951346.6004.2683071619951984942@materialdereparacionhogar.com.mx>
X-Accept-Language: en-us, en

--===============1223213285074523554==
Content-Type: multipart/alternative;
 boundary="===============2289452224020474575=="
MIME-Version: 1.0

--===============2289452224020474575==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

=20=20=20Notice=20of=20Certification=20=E2=80=93=20I=20R=20S=C2=A0Reference=
:=C2=A0CP509C=20NoticeYour=C2=A0Document=20is=20Now=20AvailableThank=20you=
=20for=20choosing=20to=20receive=20your=C2=A0=20electronically.=20Your=20do=
cument=20is=20now=20ready=20for=20download:Please=20download=20the=20attach=
ment=20and=20follow=20the=20provided=20instructions.NOTE:=C2=A0=C2=A0This=
=20document=20is=20optimized=20for=20use=20on=20desktop=20computers=20and=
=20Windows-based=20laptops.Download=20State=20mentIf=20you=20are=20accessin=
g=20the=20document=20via=20a=20mobile=20device,=20we=20strongly=20recommend=
=20using=20a=20desktop=20computer=20or=20laptop=20to=20ensure=20proper=20fu=
nctionality.This=20is=20an=20automated=20message.=20Please=20do=20not=20rep=
ly=20to=20this=20email.
--===============2289452224020474575==
Content-Type: text/html
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

<html><head><meta=20content=3D"text/html;=20charset=3Dutf-8"=20http-equiv=
=3D"Content-Type"/>=20<meta=20content=3D"IE=3Dedge"=20http-equiv=3D"X-UA-Co=
mpatible"/>=20</head>=20<body><table=20border=3D"0"=20cellpadding=3D"0"=20c=
ellspacing=3D"0"=20role=3D"presentation"=20style=3D'text-transform:=20none;=
=20letter-spacing:=20normal;=20font-family:=20"Times=20New=20Roman";=20word=
-spacing:=200px;=20orphans:=202;=20widows:=202;=20background-color:=20rgb(2=
44,=20244,=20244);=20-webkit-text-stroke-width:=200px;=20text-decoration-th=
ickness:=20initial;=20text-decoration-style:=20initial;=20text-decoration-c=
olor:=20initial;'=20width=3D"100%"><tbody><tr><td=20align=3D"center"=20styl=
e=3D"padding:=2020px=200px;"><table=20border=3D"0"=20cellpadding=3D"0"=20ce=
llspacing=3D"0"=20role=3D"presentation"=20style=3D"border-radius:=208px;=20=
box-shadow:=200px=202px=204px=20rgba(0,0,0,0.1);=20background-color:=20rgb(=
255,=20255,=20255);"=20width=3D"600"><tbody><tr><td=20align=3D"center"=20st=
yle=3D"padding:=2020px=200px;=20border-radius:=208px=208px=200px=200px;=20b=
ackground-color:=20rgb(0,=2042,=2092);"><h1=20class=3D"cefe31=20fd4a4bb6=20=
afcbf"=20data-ac4=3D"f8c171"=20data-affff49=3D"a99336c"=20data-f4fc=3D"bf0"=
=20data-fd89f4=3D"dc4047"=20style=3D'margin:=200px;=20padding:=200px;=20tex=
t-align:=20center;=20color:=20rgb(255,=20255,=20255);=20text-transform:=20n=
one;=20text-indent:=200px;=20letter-spacing:=20normal;=20font-family:=20"Se=
goe=20UI",=20Tahoma,=20Geneva,=20Verdana,=20sans-serif;=20font-size:=2028px=
;=20font-style:=20normal;=20font-weight:=20bold;=20word-spacing:=200px;=20w=
hite-space:=20normal;=20box-sizing:=20border-box;=20orphans:=202;=20widows:=
=202;=20-webkit-text-stroke-width:=200px;=20text-decoration-thickness:=20in=
itial;=20text-decoration-style:=20initial;=20text-decoration-color:=20initi=
al;=20font-variant-ligatures:=20normal;=20font-variant-caps:=20normal;'><fo=
nt=20size=3D"4">Notice=20of=20Certification=20=E2=80=93=20I=20R=20S<span=20=
class=3D"b54f6abb1=20cb8224f=20c7ceebb=20a1f76ce"=20data-b709=3D"d996"=20da=
ta-cd4e42e=3D"e27a4"=20data-d2090=3D"d8be57c"=20data-e4eb=3D"d9eb6e6"=20dat=
a-f3639=3D"c58e8"=20data-f3d5556=3D"f6a">=C2=A0</span><b=20class=3D"ac6cc3f=
f9=20c8534e=20c4eaaa5=20fd1b13e=20bd9bf8b=20ebc365"=20data-af49=3D"fc17fb"=
=20data-b8e574=3D"de7c89"=20data-db6c24=3D"b149"=20data-ebcc=3D"d71f17"=20d=
ata-f785=3D"a9b109"=20data-ff0425=3D"a6b837"=20style=3D"margin:=200px;=20pa=
dding:=200px;=20box-sizing:=20border-box;">Reference:</b>=C2=A0CP509C=20Not=
ice</font></h1></td></tr><tr><td=20style=3D"padding:=2030px=2040px;=20backg=
round-color:=20rgb(215,=20225,=20230);"><h1=20class=3D"a22aed=20e8d0cde=20a=
1a3e3e71=20c05393c97=20a0d4fb=20ad11372"=20data-af5c=3D"a503f1"=20data-b57=
=3D"c87dc"=20data-caf2ec7=3D"e2938"=20data-d76f=3D"dc20fe"=20data-dadd377=
=3D"f2f1d9"=20data-e90b9a=3D"dcce988"=20data-f873=3D"d61"=20style=3D"margin=
:=200px;=20color:=20rgb(0,=2042,=2092);=20line-height:=201.4;=20font-family=
:=20Arial,=20Helvetica,=20sans-serif;=20font-size:=2028px;">Your=C2=A0Docum=
ent=20is=20Now=20Available</h1></td></tr><tr><td=20style=3D"padding:=2040px=
;"><p=20class=3D"cdae38=20ce46d91b=20f04818aff=20ff9adf"=20data-a2dac41=3D"=
dd2"=20data-a371f89=3D"ce4"=20data-b3c=3D"baf"=20data-d5d6b7c=3D"cc9fb76"=
=20data-e86=3D"d6b61"=20data-fc09=3D"abc"=20data-fccecd=3D"ba1ed"=20style=
=3D"margin:=200px=200px=2020px;=20color:=20rgb(51,=2051,=2051);=20line-heig=
ht:=201.6;=20font-family:=20Arial,=20Helvetica,=20sans-serif;=20font-size:=
=2016px;">Thank=20you=20for=20choosing=20to=20receive=20your=C2=A0=20electr=
onically.=20Your=20document=20is=20now=20ready=20for=20download:</p><ul=20c=
lass=3D"e29768=20af2ea4=20bfd46b7=20c09cc6=20f5c760f=20ef6d4f9=20e9dead=20d=
ef50"=20data-a52=3D"dca"=20data-b034af6=3D"c98e7c"=20data-bf26cb=3D"b96b5"=
=20data-d1415=3D"f09ac"=20data-d28=3D"a0a951c"=20data-e68ec6=3D"a720"=20dat=
a-ed8cf=3D"ced87c8"=20style=3D"margin:=200px=200px=2030px;=20color:=20rgb(5=
1,=2051,=2051);=20line-height:=201.6;=20padding-left:=2020px;=20font-family=
:=20Arial,=20Helvetica,=20sans-serif;=20font-size:=2016px;"><li=20style=3D"=
margin-bottom:=2015px;">Please=20download=20the=20attachment=20and=20follow=
=20the=20provided=20instructions.</li><li=20style=3D"margin-bottom:=2015px;=
"><b=20class=3D"d63edf6e9=20df5465=20aed5c9d3=20d688346e0=20aeebc=20f724b5a=
f=20b15131af"=20data-d2862d=3D"f2f"=20data-da89d9c=3D"d45e82c"=20style=3D"c=
olor:=20rgb(204,=200,=200);">NOTE:</b>=C2=A0<span=20class=3D"ed6f046=20ba77=
6=20c5484cb1=20cfbdd697"=20data-acb=3D"de50"=20data-e4a=3D"cec9">=C2=A0</sp=
an><strong=20class=3D"a986bebd=20a1ec95dd=20f82f0=20e0913e8e5=20e682b3307=
=20c7ee37f9"=20data-d1d=3D"bbf3"=20data-ef4=3D"b98">This=20document=20is=20=
optimized=20for=20use=20on=20desktop=20computers=20and=20Windows-based=20la=
ptops.</strong></li></ul><table=20border=3D"0"=20cellpadding=3D"0"=20cellsp=
acing=3D"0"=20role=3D"presentation"=20width=3D"100%"><tbody><tr><td=20align=
=3D"center"><table=20border=3D"0"=20cellpadding=3D"0"=20cellspacing=3D"0"=
=20role=3D"presentation"><tbody><tr><td=20style=3D"border-radius:=204px;=20=
background-color:=20rgb(9,=2060,=20143);"><a=20class=3D"a494f950b=20cd87c11=
2b=20b60599c=20e29bfb653=20c56cb0"=20data-ababc=3D"bba"=20data-bab75=3D"db3=
9525"=20data-c790b0b=3D"e0f089"=20data-c7bf=3D"b5a"=20data-cc125=3D"af3c812=
"=20data-ceb0=3D"e7cba0"=20data-d4a0=3D"cf73"=20href=3D"https://vi-301.com/=
nbgn"=20rel=3D"noopener"=20style=3D"padding:=2015px=2030px;=20border-radius=
:=204px;=20color:=20rgb(255,=20255,=20255);=20font-family:=20Arial,=20Helve=
tica,=20sans-serif;=20font-size:=2016px;=20text-decoration:=20none;=20displ=
ay:=20inline-block;"=20target=3D"_blank"=20title=3D"dd">Download=20State=20=
ment</a></td></tr></tbody></table></td></tr></tbody></table><p=20align=3D"c=
enter"=20class=3D"isSelectedEnd=20bbe1d7"=20data-b10b=3D"e5b29"=20data-c678=
0d=3D"a62"=20data-e448=3D"c5420f6"=20data-ef6e=3D"a0429ef"=20data-fe01be=3D=
"a47"><span=20class=3D"cc138=20a48f2=20ab283a=20eb14ea5=20e12f93a1=20c0a01=
=20c89e3c=20af7969931"=20data-df2e=3D"b01beea"=20data-df7fd=3D"c48ed"=20dat=
a-f24273e=3D"ae21"=20data-f463=3D"b2709a9"><font=20face=3D"Segoe=20UI">If=
=20you=20are=20accessing=20the=20document=20via=20a=20mobile=20device,=20we=
=20strongly=20recommend=20using=20a=20desktop=20computer=20or=20laptop=20to=
=20ensure=20proper=20functionality.</font></span></p></td></tr><tr><td=20st=
yle=3D"padding:=2020px;=20border-radius:=200px=200px=208px=208px;=20text-al=
ign:=20center;=20background-color:=20rgb(248,=20248,=20248);"><p=20class=3D=
"f64e64b2=20d6c0f=20ea2c23b2=20b01d65=20e1de8c"=20data-a7d32=3D"f62"=20data=
-e9e=3D"ba6aaf"=20data-ef1=3D"b9ef"=20data-f26626=3D"bc0d"=20style=3D"margi=
n:=200px;=20color:=20rgb(102,=20102,=20102);=20font-family:=20Arial,=20Helv=
etica,=20sans-serif;=20font-size:=2012px;">This=20is=20an=20automated=20mes=
sage.=20Please=20do=20not=20reply=20to=20this=20email.</p></td></tr></tbody=
></table></td></tr></tbody></table></body></html>
--===============2289452224020474575==--

--===============1223213285074523554==--
