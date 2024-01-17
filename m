Received: from mail.buzzsy24.com (mail.buzzsy24.com [80.211.148.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC104134A9
	for <linux-raid@vger.kernel.org>; Wed, 17 Jan 2024 09:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.211.148.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705483306; cv=none; b=o/cWC7gL8YCFkcAzlSRTeBQGTn9ruy5cUMh7PmuHVtPWv2Yr7GjO4CDa3xJmafQhmF8psjmFnQdBBZgGA7wW4+J+hXktjgaWRuTu6qBK39DZBaXNPZZP8spDUxlOKj1Un+WAhMqQjiTxd8v4uWEXntXr8wjf8NKwejqomk1P5yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705483306; c=relaxed/simple;
	bh=gLeKu26yGksf2iyOErfq3dCuES81BL9/oHuJZQm5U3g=;
	h=Received:DKIM-Signature:Received:Message-ID:Date:From:To:Subject:
	 X-Mailer:MIME-Version:Content-Type:Content-Transfer-Encoding; b=Oa8cd9lGEJHVJd4h6VQ0cjy0wx2xE9YMz3XEmycRPo43BZu/klPLX++9qHUjNufxJkMHKuBNjkidDnToBPcB04rlaATcFhyWDYI4NXZ/ZQRzcO74wNQk5ah+PBkyWHfbmMg9pJYYdBZilaW0Z4rTfG4NyomB90FXTngAxf45eg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=buzzsy24.com; spf=pass smtp.mailfrom=buzzsy24.com; dkim=pass (2048-bit key) header.d=buzzsy24.com header.i=@buzzsy24.com header.b=xrXLWmS3; arc=none smtp.client-ip=80.211.148.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=buzzsy24.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=buzzsy24.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=buzzsy24.com header.i=@buzzsy24.com header.b="xrXLWmS3"
Received: by mail.buzzsy24.com (Postfix, from userid 1002)
	id 1D7AD8296D; Wed, 17 Jan 2024 10:16:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=buzzsy24.com; s=mail;
	t=1705482976; bh=gLeKu26yGksf2iyOErfq3dCuES81BL9/oHuJZQm5U3g=;
	h=Date:From:To:Subject:From;
	b=xrXLWmS3qNmjKrwSYvBOpDvrmAdK/ZIW8MZZkGfkDv3Q9PXig7Rvq65muQFEHak0d
	 gMtpy3tPyDqDzoR0SFJRjbVTITPDwI84V1QDCShBavApb0eAmoiZfg+uSn0qnlXJOC
	 YeC3XD30hxbomUNwNL/aseYkdlEmJZWolV6uOIlmLPpXt2zImOCofWGmMaNIxTMHoj
	 0BGdMyTkYWiB13i9D1XQqYUy75ZtSL6ZEj6zVoW5WtU9JNcLWBtGyklZVlW7JLC9qR
	 znYFtuN5uJsJBMH7YNH+COx5HRprgfn+BFEkP03oaHbkXWXIA6OuX2dpeNcKvYheRn
	 fDegiIeHmhn3w==
Received: by mail.buzzsy24.com for <linux-raid@vger.kernel.org>; Wed, 17 Jan 2024 09:16:05 GMT
Message-ID: <20240117084500-0.1.c.juq.0.42050yqd20@buzzsy24.com>
Date: Wed, 17 Jan 2024 09:16:05 GMT
From: "Benjamin Desaulniers" <benjamin.desaulniers@buzzsy24.com>
To: <linux-raid@vger.kernel.org>
Subject: Serial production of components with machining
X-Mailer: mail.buzzsy24.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Are you interested in cooperation with an experienced partner in the fiel=
d of machining, milling, drilling, boring, reaming or surface grinding?

We prepare a product tailored to the expectations of your company and cre=
ated for its needs. We provide full technical advice and comprehensive se=
rvice in the production of machine parts and components, but also in the =
design and construction of machines.

Let me know if you are interested in a short conversation regarding the o=
rder.


Best regards
Benjamin Desaulniers
