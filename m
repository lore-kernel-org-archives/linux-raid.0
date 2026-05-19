Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7A135201F
	for <linux-raid@vger.kernel.org>; Tue, 19 May 2026 17:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779211740; cv=pass; b=F8rg6UWEqhHac1PNbnb3oAsZNNwdzKhKeaXxz4RgKJyDomzvvEJYN1xow+Kgjgt0GxgjExmS9SO4qIdaHndZW1jUjcRbyw7q3m2HTH/eNYSwRDoYzxC+8U+qAmL9lj58Z2HvRDDdygBArf4wuxhS/MWTJ+OhdzK2voJAnfmNdRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779211740; c=relaxed/simple;
	bh=UqXVxskGAYnzY8FUlqjXpVsUjLPIdV+xPESuQpnjoW0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=uZ6j0v01SyZQ5k29moTSeq9uRzFCXp7zgq4sXh5W5nIFU+M6jaEshOsOf2brg3Irk5KnZOO/ZZ+x3EX+1XjuN9DmA8o/T6wfyTpzoFmS+zNMR313Zj7zj+x2pfdbiBQQoPEEpHXNIkCyRwEafDvpdFuHPLlQwun+do70PSnSA2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L6F3rFUk; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6F3rFUk"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-67e43a8996fso4878928a12.0
        for <linux-raid@vger.kernel.org>; Tue, 19 May 2026 10:28:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779211736; cv=none;
        d=google.com; s=arc-20240605;
        b=W+kp1xI6tlVzcXGmjKeCl6Hl6ysG877CoFxhnToP8X1AXq3LTCR1664LYWmo9oIFWT
         G6ROmde+PjkRC7KO2Lq9yyB3jLNB8rnqMfmoL69pmuDewkBWnvD0VOqQd5lEcMFhuKSE
         9cXj5gCrsn9qg4dHuYyXMMjzCf+sLRYV2q+VgkRcUmsQRK6j7/sbXC2h3aJdpygkrwx5
         Akau8xFlM4vxWgFPMfQ7hm9dMGULkkt8w6IUQtDYMnwkEyAfRnBmE3KDent9eqPEyqNy
         Qeyr9NtuSlKOU3RmIAwYAk+ya/gqVeBfLuU13tKt5WW4uMdW+KbOWzAJXpmk9QN8SFJZ
         Xbwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=UqXVxskGAYnzY8FUlqjXpVsUjLPIdV+xPESuQpnjoW0=;
        fh=X3wQ2D3DBAZuXswHTOsYFcAief3bMBJ7HKWbj/5u/jo=;
        b=N6R08U6oubPRgCHBDJg3fuCL8IQqmLVnLAYN7i7om8+wJwGSFdZPeCpp4E7dgOSV9r
         xOd56Tmt7AtstH+ltioxYKgo09vIJaTEuhfeQoPjl6GowXNs6egU4OLORd/Xa2A6Av8G
         +FVQ8fUiWIdAQTCdbVEODkPjcIU0d9nPnQyeNJuOC2a/zm24WK1T7Zp9y9jSWU7NV07L
         OrP0bLjD4KCpq3GA8QmlCK928Vlpb7jaiIlxG4FfVPwjnzjIK3WWej5ZYTLtosHFRGxd
         rK6hZUo7QDnFKxy36nLzulfqmL+9lCEXzrHp4YwiOyDMgHtY3zjxTLArXVR1RIqFVrFD
         m1qg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779211736; x=1779816536; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UqXVxskGAYnzY8FUlqjXpVsUjLPIdV+xPESuQpnjoW0=;
        b=L6F3rFUkS5K2lFoV7XOxGpWFS71cOnNX3XgOHow+XhjQcVMDBqwcI17egnIPmb3SzZ
         IvbaUZdS1rGXSU17A5J5mEctKt3z3YjZGhebYAifq38BPAMQCb9eRh41I5VsuTMh+h3E
         8VIIbndazmv/sXzcKQFlFdGQnDOeCCEpv46V+02b/duYxUU7aHrw/sczhT0w3v6N/OSK
         s0u1uzH3aGCivft53PhjtJVKqZcev6C14rIWEIoX6hf9UVamtc/L9mc3GNaT3HgIlUYV
         5WTyU+kmsxzF35ozR7ELqZz2+kJPq7TrkidPSWe+PbjN/Om05JGnpz1O9ceUICg7o4fE
         9RJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779211736; x=1779816536;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UqXVxskGAYnzY8FUlqjXpVsUjLPIdV+xPESuQpnjoW0=;
        b=GOKDR1qcpKng7Bk22c2/ycUbwqO04Q52h+u1bY8vdH5dVTIOMk3K/QT9KgusjnZFWh
         QvL5i+gIIXtygXMFFwuv0bOFYid61/d2TdT6jKNYGIfH5Hjy0k2gPnKwDA2fOcq7lU4Y
         +OmAxnRfITEjR/U6oXsscPJJLb0CaXWav1ReJi3pPVg990Jmv5Jt8dF/YvRi+WRzGykW
         txxeemH36bZQ5MD4eUmjdMoB0bxzK2qZBMJwHKHvhV8jxK30jhDc1sHjUTvJEu5xt37u
         gbQ4kSAkuTuX5MMXsI3vrw9ZTovNUqGXXOCeLiL+wYq1ggD6LlJ8keyhnkAJd5dico1L
         K/Xw==
X-Gm-Message-State: AOJu0YxnJADc3htBYwGyzRtqHHTgqERmr7vUGTuDopcY6CoQ3RxzC2ph
	Sm5mrMqR89LEHCk1WB8C4iZ1a/bwV0tCKThw7mwlFUuvoc8zCQQCrxTtv0F5p+m7WAYODooRMqI
	8fq5y98IS/M59ZKkNPvk1i1aprJp2D64J1FVl
X-Gm-Gg: Acq92OHboPjLJ7jGaZVxOAuj8xs0bQYzR91BBhHbRq3oiOLmeT8L1X2NJDuNX0s4/1F
	wwoJD8rqpWC5EY+c7RnOnhMTT806VWB25VKdIC7PZ9lcGhDtdGbKN15WHnFf3qYz1sgoMv5kN9U
	ZuAoRVcaFZjMFkopEX00K4IYoxfFxwJeSONxW0fEaB1S3hHfo1Aw3skqiFDk2nJjyUOjuJOhR+y
	UaCnQNoPewBQhmmGDyXhV3+Fv1G/aWHtxBYkQ2xKw0WjnYQkfCF0kLjHHcRCTgq0eMV8wnjyn1f
	AACb7rvK
X-Received: by 2002:a17:906:6a01:b0:bbe:384e:4c4d with SMTP id
 a640c23a62f3a-bd5177ee4e7mr1166435266b.14.1779211736143; Tue, 19 May 2026
 10:28:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Tue, 19 May 2026 20:28:44 +0300
X-Gm-Features: AVHnY4IFRVx2jMMQA-AYVvkSSntntABduBT0VXqKQVAZhZjsIWnrieJ1S5jahGo
Message-ID: <CAAiJnjpPAur30W4FO2sTZcYWc24yFafKWGR=BZWZsh2JnbrRpQ@mail.gmail.com>
Subject: --bitmap=lockless across server reboot
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi

Does md-raid lockless bitmap support server's reboot ?

I don't see md-raid6 created with --bitmap=lockless after reboot.

Anton
