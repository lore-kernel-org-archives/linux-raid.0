Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.130.137.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792608712;
	b=K7cX0cccacufSk7RX1shxqjNwHMpsL+4JPnCHEA3IiS/ioRIrd/gdpbObqQNqPP6qI1I
	 fggLko/FRRbIEask9fl32k54Gqr720Ksc+w6ab+H9VaaWx66tVXUnBJ75LrorzymG6iLa
	 ft4NrzlH6kRnPWD04V2VuQ5bmtLQP/GVfx4ce6dmuQt4gSsP4rDAycMVVDoA0jXLbzkbM
	 nVtcsVNviVRJHzS9QCz1VLMjqD0TXAC40AdR0nX6UdoZ5wp4JVzHMPqZJCiSBVI4Vjw9v
	 qpxc+Lgp2qW1ASmUVmiJ1onhtg4aOqFqCyqsFYPJWx834tgdYQ8lZbZc2NGE1L5H8bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792608712;
	h=DMARC-Filter:DKIM-Signature:X-Country-Code:Received:Content-Type:
	 MIME-Version:From:To:Subject:Date:Message-ID:X-Accept-Language:
	 REPLY-TO;
	bh=st16u5TiMtwAbn4uOkNRMnCoo2WZwY9c5F2mkPggdbw=;
	b=si0D1vLDQ1WeNbI05FfVxoPTuQau/4HkxPFj0rNwwcoXDP0Auw/1hByTTgHvoe9m9Kn0
	 tK6RHOfM9lHWNB7afTrbKqmAUmecWozSR6HjL6/eJsgXbFeKfjdUHeDa6uuNn71cn/kRT
	 Li3XNXPOo36zMW0ewlW2KlBkidM39WoGZo89qAJf6vadMuZKlwFv/UfI8CP9xSqux9jDt
	 Ax8DztveueHpAx99MGbuOmmp6R828oGBzFgyRCy12zTRVJfYeDXi0Dg8w6vcxpkMhvS0s
	 m6CBh50D3AH33uh4InadABAlp5PD3tqwYIIcpqGolkwF1Ad1IVzJu1JodRlAgTqqEwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asahi-net.or.jp;
	spf=pass smtp.mailfrom=asahi-net.or.jp;
	dkim=pass header.d=asahi-net.or.jp header.i=ea9a-mtmt@asahi-net.or.jp header.a=rsa-sha256 header.s=x02 header.b=fQcpNoCa;
	arc=none smtp.remote-ip=210.130.137.7
Received: from hsmtpd-dty-c1101.xspmail.jp (hsmtpd-dty-c1101.xspmail.jp [210.130.137.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE9F606A31B
	for <linux-raid@vger.kernel.org>; Wed, 21 Oct 2026 18:51:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAE9F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asahi-net.or.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asahi-net.or.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asahi-net.or.jp header.i=ea9a-mtmt@asahi-net.or.jp header.a=rsa-sha256 header.s=x02 header.b=fQcpNoCa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792608702;
	d=asahi-net.or.jp; s=x02; i=ea9a-mtmt@asahi-net.or.jp;
	h=reply-to:message-id:date:subject:to:from:mime-version:content-type:from;
	bh=st16u5TiMtwAbn4uOkNRMnCoo2WZwY9c5F2mkPggdbw=;
	b=fQcpNoCai3miUrFt9OTlJZb5M6/Z05wLcUIgPPQ+4weR+iEn230/ap/MvU8bVme/OBjrAN9RPDHKs
	 CW2J9cqTXNQRSVFk2DTDlOvNl023hqRdqI5M+BFg6jhDlFNgFIO692hTMRH82mea8Cq77BGLkoQLYn
	 jCWFofaizLmwG9RT1l71jiVYabDTrXTh6bX408vl5LsIAC1eNtS15O9lMg+rlVGTqIZTcYtxyL2HjC
	 Zbep4GKAcbwLYJAaWZrQdGnwPRu2Jebut4H9nHB0s+BURg7eND01xYfwFUF2iO7F5w/h6Xy68OgbYx
	 pIzyo/mzx1pHzLXJZdoTvU8yZKfXRZQ==
X-Country-Code: US
Received: from 7d22f675.in (ec2-44-251-124-252.us-west-2.compute.amazonaws.com [44.251.124.252])
	by hsmtpd-out-3.asahinet.c1101.xspmail.jp (Halon) with ESMTPSA (TLSv1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	id 12f4d9b7-4acf-436a-be25-adceecac2682;
	Thu, 22 Oct 2026 03:51:42 +0900 (JST)
Content-Type: multipart/mixed; boundary="===============5676393083093520617=="
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Luna Honorio <ea9a-mtmt@asahi-net.or.jp>
To: linux-raid@vger.kernel.org
Subject: Product inquiry
Date: Wed, 21 Oct 2026 18:51:40 -0000
Message-ID: <179260870085.2124.13099688364720931553@asahi-net.or.jp>
X-Accept-Language: en-us, en
REPLY-TO: luna.honorio@colegiosaofranciscoassis.com.br

--===============5676393083093520617==
Content-Type: multipart/alternative;
 boundary="===============4489207901494134437=="
MIME-Version: 1.0

--===============4489207901494134437==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64

R29vZCBkYXksDQoNCkknbSBpbnRlcmVzdGVkIGluIHB1cmNoYXNpbmcgeW91ciBwcm9kdWN0cyBp
biBsYXJnZXIgcXVhbnRpdGllcyBhbmQgd291bGQgbGlrZSB0byBsZWFybiBtb3JlIGFib3V0IHdo
YXQgeW91IGN1cnJlbnRseSBoYXZlIGF2YWlsYWJsZS4NCg0KQ291bGQgeW91IHBsZWFzZSBzZW5k
IG1lIHlvdXIgbGF0ZXN0IHByb2R1Y3QgbGlzdC9jYXRhbG9nIGFuZCBwcmljZXMsIGluY2x1ZGlu
ZyBhbnkgYnVsay1vcmRlciBwcmljaW5nPw0KDQpUaGFuayB5b3UsIGFuZCBJIGxvb2sgZm9yd2Fy
ZCB0byB5b3VyIHJlc3BvbnNlLg0KDQpCZXN0IHJlZ2FyZHMsDQpMdW5hIEhvbm9yaW8=

--===============4489207901494134437==
Content-Type: multipart/relative;
 boundary="===============3255034168561268297=="
MIME-Version: 1.0

--===============3255034168561268297==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64

R29vZCBkYXksDQoNCkknbSBpbnRlcmVzdGVkIGluIHB1cmNoYXNpbmcgeW91ciBwcm9kdWN0cyBp
biBsYXJnZXIgcXVhbnRpdGllcyBhbmQgd291bGQgbGlrZSB0byBsZWFybiBtb3JlIGFib3V0IHdo
YXQgeW91IGN1cnJlbnRseSBoYXZlIGF2YWlsYWJsZS4NCg0KQ291bGQgeW91IHBsZWFzZSBzZW5k
IG1lIHlvdXIgbGF0ZXN0IHByb2R1Y3QgbGlzdC9jYXRhbG9nIGFuZCBwcmljZXMsIGluY2x1ZGlu
ZyBhbnkgYnVsay1vcmRlciBwcmljaW5nPw0KDQpUaGFuayB5b3UsIGFuZCBJIGxvb2sgZm9yd2Fy
ZCB0byB5b3VyIHJlc3BvbnNlLg0KDQpCZXN0IHJlZ2FyZHMsDQpMdW5hIEhvbm9yaW8=

--===============3255034168561268297==--

--===============4489207901494134437==--

--===============5676393083093520617==--
