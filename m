Received: from s1.sapience.com (s1.sapience.com [72.84.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189104778E;
	Tue, 19 Nov 2024 13:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=72.84.236.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732023072; cv=fail; b=qp0H2agpmC78jhWMtdlG8xzEoBKcm3E4BucNcD9DpDHwLWOgQIJx1nI/ba7pG3Dj98EHzP8L+VIBgpigEjOnYHmuiHf1BfcTDtNnEPcZyJTA/NpO3YH1LzHEm2sc8PS2BqTVuIeAnqJ+Q5l0zJG2uxHGSe5WFykuFI2pWvS2UNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732023072; c=relaxed/simple;
	bh=vbObzj+bjxeFRKyo/6Ql4FmVCIkj4Ih3phDM45GSptc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IyBXj+noGW2zdO8VVfBIOKYIM/rBV0ZZdUqrxs1qFb26VlttpepNhlfFCk4zVQVQc2iKRdHh/q4Eth8llGkGGWuYe7wxfLUhalNfR0xrtOVs3K0Drbel5/RlHJFFfU92XyG39LTxC8dcOeFO7h/MUpFhHMHCdl9UQYf2GjptQgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com; spf=pass smtp.mailfrom=sapience.com; dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b=c/QTlNr2; dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b=Okf1+Zi0; arc=fail smtp.client-ip=72.84.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sapience.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b="c/QTlNr2";
	dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b="Okf1+Zi0"
Authentication-Results: dkim-srvy7; dkim=pass (Good ed25519-sha256 
   signature) header.d=sapience.com header.i=@sapience.com 
   header.a=ed25519-sha256; dkim=pass (Good 2048 bit rsa-sha256 signature) 
   header.d=sapience.com header.i=@sapience.com header.a=rsa-sha256
Received: from srv8.sapience.com (srv8.sapience.com [x.x.x.x])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by s1.sapience.com (Postfix) with ESMTPS id 61F69480AB5;
	Tue, 19 Nov 2024 08:31:03 -0500 (EST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-ed25519-220413; t=1732023063;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=iVhrAsPP1o0K6VYLQh1gnoBRVgdV6zhgZ6ruKhOzY0U=;
 b=c/QTlNr2Sb3WDD8OkTuyawvi8I6uFEnQ8b3bHvIkq2C2LE6msFd0PxYeZulYmfuKUwcEe
 zcKpgR5BphaSEZcBA==
ARC-Seal: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412; t=1732023063;
	cv=none; b=gxGqRzAhw/scAQ/wBKmJVSV4GFnh2rGJM9nRWWpN/iVsZvyg+mFjWiEwHxnnCXOnlY9RRxESeUmTwjobgfgZDju1nk/6C82el/JFhLnEDXiI17b5B/3AbWkL0FzVQ8c5p7l15o6Mnl+WdbMZjf7frw9Ydt5xr6El4UgqseYPJ/BIfVRQDB+V1Y5Ij8Pi8OHucsF8iOZJI6wmowenUEclVDfp7UTHBLoLFNCQ5j8f/sCbEG1vl96mUdY4NdVumkbwciRzFnG+QRq91a+Lw0a+dzFieq1VnNPaYki/ACpKJ4ld2sS26AlV+tNw0O6viTyH6Pejymgtnz3aM1oCM5ltUw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412;
	t=1732023063; c=relaxed/simple;
	bh=vbObzj+bjxeFRKyo/6Ql4FmVCIkj4Ih3phDM45GSptc=;
	h=DKIM-Signature:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Autocrypt:Content-Type:User-Agent:
	 MIME-Version; b=a4DR51nlNPm6FZD0UR+goL994bIVzObwjhGF417eDaIXn6id3oOBwq/cFK5jLOP1SMR/43cC5ldPcGAoxZktHiCXu0TXUrx+GLCxWQah+E/WznmiAYX50mtv6KBbCKbdQZG6bsOjRBZz/Q8rT0Oi0215rrk0wvIrAhxetxCbfAB1TJ8LwecEDKAR/BJPnH1FbcjOOG3cXj9R9qO4YkCsmKflUeFXci48LIBSoO1ZdBrZbbblsQyEjZi8qLlef4LCeAOhmdDXVr6YtAyN5slHmx1739JWqtPNLF1g3KhIKZPURDUWPdyEj6P6rzPZlF5+sMq2KOk5XuuCKaMvO7ys8w==
ARC-Authentication-Results: i=1; arc-srv8.sapience.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-rsa-220413; t=1732023063;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=iVhrAsPP1o0K6VYLQh1gnoBRVgdV6zhgZ6ruKhOzY0U=;
 b=Okf1+Zi07YJet2Zh9pkSnPdEy4lQR0DYT1c2l9wHQRNkVmIAj5EoH/wY1anHeT5HsMXb3
 s5JtPJZKZL7Lq96+XZp6Y0uzMTL8FKoz2xTHozmM5MetHdhdB9YrhT1SU5jdscLan7N5YgB
 v74MTGYcQKdsFVXjaze6sO6pDTBtEIwPMqmUQYz0Y9xAVSBR0s8bps0NEHrXAH7AA0hfveC
 fk6Tc1hclHh4l5e2+Kq4Bf9kusv+9axZ1Uq3v+9z/WuiX5gw7GgAZMCkd2ccgLnj2c0eW+J
 Z8f1OyS3jayiTmpJ3kG/JguIjpt2EsUXMBJOvz06Wj/x6tst1alkgWmyp7yA==
Received: from lap7.sapience.com (lap7w.sapience.com [x.x.x.x])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by srv8.sapience.com (Postfix) with ESMTPS id 28D67280047;
	Tue, 19 Nov 2024 08:31:03 -0500 (EST)
Message-ID: <ef8bd4f9308dbf941076b2f7bd8a81590a09aa5e.camel@sapience.com>
Subject: Re: md-raid  6.11.8 page fault oops
From: Genes Lists <lists@sapience.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	linux@leemhuis.info
Date: Tue, 19 Nov 2024 08:31:02 -0500
In-Reply-To: <Zzx34Mm5K42GWyKj@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <0b579808e848171fc64e04f0629e24735d034d32.camel@sapience.com>
	 <34333c67f5490cda041bc0cbe4336b94271d5b49.camel@sapience.com>
	 <Zzx34Mm5K42GWyKj@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
Autocrypt: addr=lists@sapience.com; prefer-encrypt=mutual;
 keydata=mDMEXSY9GRYJKwYBBAHaRw8BAQdAwzFfmp+m0ldl2vgmbtPC/XN7/k5vscpADq3BmRy5R
 7y0LU1haWwgTGlzdHMgKEwwIDIwMTkwNzEwKSA8bGlzdHNAc2FwaWVuY2UuY29tPoiWBBMWCAA+Ah
 sBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEE5YMoUxcbEgQOvOMKc+dlCv6PxQAFAmPJfooFCRl
 vRHEACgkQc+dlCv6PxQAc/wEA/Dbmg91DOGXll0OW1GKaZQGQDl7fHibMOKRGC6X/emoA+wQR5FIz
 BnV/PrXbao8LS/h0tSkeXgPsYxrzvfZInIAC
Content-Type: multipart/signed; micalg="pgp-sha384";
	protocol="application/pgp-signature"; boundary="=-22X8WIaCT3AexQthvRmq"
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-22X8WIaCT3AexQthvRmq
Content-Type: multipart/alternative; boundary="=-oKegJe8IFJzT9ta3Wa56"

--=-oKegJe8IFJzT9ta3Wa56
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

T24gVHVlLCAyMDI0LTExLTE5IGF0IDE3OjA0ICswNTMwLCBPamFzd2luIE11am9vIHdyb3RlOgo+
ID4gCi4uLgoKPiA+IMKgKGdkYikgbGlzdCAqKHJiX2ZpcnN0KzB4MTMpCj4gPiDCoCAweGZmZmZm
ZmZmODFkZTFhZjMgaXMgaW4gcmJfZmlyc3QgKGxpYi9yYnRyZWUuYzo0NzMpLgo+ID4gwqAgNDY4
wqDCoMKgwqDCoMKgIHN0cnVjdCByYl9ub2RlwqAgKm47Cj4gPiDCoCA0NjkKPiA+IMKgIDQ3MMKg
wqDCoMKgwqDCoCBuID0gcm9vdC0+cmJfbm9kZTsKPiA+IMKgIDQ3McKgwqDCoMKgwqDCoCBpZiAo
IW4pCj4gPiDCoCA0NzLCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gTlVMTDsKPiA+IMKgIDQ3
M8KgwqDCoMKgwqDCoCB3aGlsZSAobi0+cmJfbGVmdCkKPiAKPiBOb3cgdGhpcyBsb29rcyBzdHJh
bmdlLCB3ZSBhbHJlYWR5IG1ha2Ugc3VyZSBuIGlzIG5vdCBOVUxMIGFuZCB0aGVuCj4gc29tZWhv
dyB0aGlzIGxpbmUgZW5kcyB1cCBpbgo+IAo+IMKgQlVHOiB1bmFibGUgdG8gaGFuZGxlIHBhZ2Ug
ZmF1bHQgZm9yIGFkZHJlc3M6IDAwMDAwMDAwMDAyMDAwMTAKPiAKPiBOb3csIGRlY29kaW5nIHRo
ZSBjb2RlIHdpdGggYW4geDg2IHZtbGludXgsIEkgc2VlIHRoZSBmYXVsaW5nIG9wY29kZQo+IGZh
dWx0aW5nOgo+IAo+IENvZGUgc3RhcnRpbmcgd2l0aCB0aGUgZmF1bHRpbmcgaW5zdHJ1Y3Rpb24K
PiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Cj4gwqDCoCAwOsKg
wqAgMGYgMWYgODAgMDAgMDAgMDAgMDDCoMKgwqAgbm9wbMKgwqAgMHgwKCVyYXgpCj4gwqDCoCA3
OsKgwqAgOTDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbm9wCj4g
wqDCoCA4OsKgwqAgOTDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
bm9wCj4gwqDCoCA5OsKgwqAgOTDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgbm9wCj4gwqDCoCBhOsKgwqAgOTDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgbm9wCj4gwqDCoCBiOsKgwqAgOTDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgbm9wCj4gwqDCoCBjOsKgwqAgOTDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbm9wCj4gwqDCoCBkOsKgwqAgOTDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbm9wCj4gwqDCoCBlOsKgwqAgOTDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbm9wCj4gwqDCoCBmOsKgwqAgOTDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbm9wCj4gCj4gTm93IFJB
WCBpcyAweDIwMDAwMCBidXQgSSBkb24ndCB0aGluayB0aGUgbm9wbCBpbnN0cnVjdGlvbiBzaG91
bGQKPiBoYXZlIHJlc3VsdGVkCj4gaW4gYSBtZW0gYWNjZXNzIEFGQSBteSBsaW1pdGVkIHVuZGVy
c3RhbmRpbmcgb2YgeDg2IElTQSBnb2VzLgo+IAo+IEkgYWxzbyBkb24ndCBzZWUgbm9wbCBpbiBt
eSB2bWxpbnV4IGluIHJiX2ZpcnN0LCBteSBiaW5hcnkgYmVpbmcKPiBjb21waWxlZCB3aXRoCj4g
Z2NjIDguNS4gQXJlIHlvdSBieSBjaGFuY2UgdXNpbmcgY2xhbmcgb3IgaGlnaGVyIHZlcnNpb24g
b3IgaGlnaGVyCj4gb3B0aW1pemF0aW9uIGluIGdjYy4KPiAKPiBSZWdhcmRzLAo+IG9qYXN3aW4K
CkkgYW0gdXNpbmcgQXJjaCB0b29sY2hhaW4gd2l0aMKgCgrCoCDCoGdjYyAxNC4yLjErcjEzNCtn
YWI4ODRmZmZlM2ZjLTEKCkkgZG8gbm90IHNldCBDRkxBR1NfS0VSTkVMIMKgc28gY29tcGlsZSBv
cHRpb25zIGFyZSB0aGUgZGVmYXVsdC4KCnRoYW5rcwoKZ2VuZQoKCg==


--=-oKegJe8IFJzT9ta3Wa56
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head><style>pre,code,address {
  margin: 0px;
}
h1,h2,h3,h4,h5,h6 {
  margin-top: 0.2em;
  margin-bottom: 0.2em;
}
ol,ul {
  margin-top: 0em;
  margin-bottom: 0em;
}
blockquote {
  margin-top: 0em;
  margin-bottom: 0em;
}
</style></head><body><div>On Tue, 2024-11-19 at 17:04 +0530, Ojaswin Mujoo =
wrote:</div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-le=
ft:2px #729fcf solid;padding-left:1ex"><blockquote type=3D"cite" style=3D"m=
argin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><div><br>=
</div></blockquote></blockquote><div>...</div><div><br></div><blockquote ty=
pe=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;paddi=
ng-left:1ex"><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-l=
eft:2px #729fcf solid;padding-left:1ex"><div>&nbsp;(gdb) list *(rb_first+0x=
13)<br></div><div>&nbsp; 0xffffffff81de1af3 is in rb_first (lib/rbtree.c:47=
3).<br></div><div>&nbsp; 468&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct rb_=
node&nbsp; *n;<br></div><div>&nbsp; 469<br></div><div>&nbsp; 470&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; n =3D root-&gt;rb_node;<br></div><div>&nbsp; 471&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!n)<br></div><div>&nbsp; 472&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return NULL;<br></div=
><div>&nbsp; 473&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; while (n-&gt;rb_left)<=
br></div></blockquote><div><br></div><div>Now this looks strange, we alread=
y make sure n is not NULL and then<br></div><div>somehow this line ends up =
in<br></div><div><br></div><div>&nbsp;BUG: unable to handle page fault for =
address: 0000000000200010<br></div><div><br></div><div>Now, decoding the co=
de with an x86 vmlinux, I see the fauling opcode<br></div><div>faulting:<br=
></div><div><br></div><div>Code starting with the faulting instruction<br><=
/div><div>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br></div=
><div>&nbsp;&nbsp; 0:&nbsp;&nbsp; 0f 1f 80 00 00 00 00&nbsp;&nbsp;&nbsp; no=
pl&nbsp;&nbsp; 0x0(%rax)<br></div><div>&nbsp;&nbsp; 7:&nbsp;&nbsp; 90&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; nop<br></div><div>&nbsp;&nbsp=
; 8:&nbsp;&nbsp; 90&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; nop<=
br></div><div>&nbsp;&nbsp; 9:&nbsp;&nbsp; 90&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; nop<br></div><div>&nbsp;&nbsp; a:&nbsp;&nbsp; 90&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; nop<br></div><div>&nbsp;&nbsp=
; b:&nbsp;&nbsp; 90&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; nop<=
br></div><div>&nbsp;&nbsp; c:&nbsp;&nbsp; 90&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; nop<br></div><div>&nbsp;&nbsp; d:&nbsp;&nbsp; 90&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; nop<br></div><div>&nbsp;&nbsp=
; e:&nbsp;&nbsp; 90&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; nop<=
br></div><div>&nbsp;&nbsp; f:&nbsp;&nbsp; 90&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; nop<br></div><div><br></div><div>Now RAX is 0x200000 b=
ut I don't think the nopl instruction should have resulted<br></div><div>in=
 a mem access AFA my limited understanding of x86 ISA goes.<br></div><div><=
br></div><div>I also don't see nopl in my vmlinux in rb_first, my binary be=
ing compiled with<br></div><div>gcc 8.5. Are you by chance using clang or h=
igher version or higher optimization in gcc.<br></div><div><br></div><div>R=
egards,<br></div><div>ojaswin<br></div></blockquote><div><br></div><div>I a=
m using Arch toolchain with&nbsp;</div><div><br></div><div>&nbsp; &nbsp;gcc=
 14.2.1+r134+gab884fffe3fc-1</div><div><br></div><div>I do not set CFLAGS_K=
ERNEL &nbsp;so compile options are the default.</div><div><br></div><div>th=
anks</div><div><br></div><div>gene</div><div><br></div><div><br></div></bod=
y></html>

--=-oKegJe8IFJzT9ta3Wa56--

--=-22X8WIaCT3AexQthvRmq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYJAB0WIQRByXNdQO2KDRJ2iXo5BdB0L6Ze2wUCZzyTFgAKCRA5BdB0L6Ze
22lRAPwIC9zcnlniEgLBIaY96wS2abxAw3LVHrvMTZeE70sU1AEAuwHvsIc6U8aD
Dt6m7nOvlaaTo3bZxtibX0pJgy/XNwc=
=+ALZ
-----END PGP SIGNATURE-----

--=-22X8WIaCT3AexQthvRmq--
