Received: from spe3.ucebox.co.za (spe3.ucebox.co.za [197.242.159.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8790E1F81AF
	for <linux-raid@vger.kernel.org>; Fri, 25 Oct 2024 11:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=197.242.159.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729854153; cv=none; b=uUzQSHQlWlcUhJKg5S9rz7+Hf/YxlFBkosMp4t+mxEkGbSg5rWrDF8j1kOhuPjoCuc+xfBgL1XSXeAVzjyv1f98mnt8UMHyE0lOf4a9k7BXCyi96fCNIUKHZ2SyAPZWaI4mD+7BvG6dhLDBcu2i0uDYQprwEwKH/7iK5HBfeUlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729854153; c=relaxed/simple;
	bh=R2SO4Uh4OoOI+5zfsT+aIImi6Lft6YeI+xNybVwTTVs=;
	h=To:Subject:Date:From:Message-ID:MIME-Version:Content-Type; b=a+1EKm3v9G6fif07uijyT67zWXJcuhhzYex9OUjTPn+1UHr5imcfpHkX9exKDulu4ok+2nDsB34STK9xAOPfPqQ+JIWAnXMpHRI2RkBcdkW79AAKLSIRDz5eJjsOrdz7Izv8vakJELWj4oulPl+94Ca/riuPxM1yIifqbRi3vdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ucebox.co.za; spf=pass smtp.mailfrom=ucebox.co.za; arc=none smtp.client-ip=197.242.159.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ucebox.co.za
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucebox.co.za
Received: from crookshanks.aserv.co.za ([154.0.175.149])
	by spe5.ucebox.co.za with esmtps (TLSv1.2:AES128-GCM-SHA256:128)
	(Exim 4.92)
	(envelope-from <support@ucebox.co.za>)
	id 1t4H0q-0043Y6-CX
	for linux-raid@vger.kernel.org; Fri, 25 Oct 2024 11:53:48 +0200
Received: by crookshanks.aserv.co.za (Postfix, from userid 1360)
	id D68441C234E; Fri, 25 Oct 2024 11:37:54 +0200 (SAST)
To: linux-raid@vger.kernel.org
Subject: Greetings from Bahrain Investors Group.
X-PHP-Originating-Script: 1360:m1.php
Date: Fri, 25 Oct 2024 09:37:54 +0000
From: Faisal Al Rasbi <support@ucebox.co.za>
Reply-To: bahinvestec@daum.net
Message-ID: <a13e07eb47327081c94bddddadf301fe@spectrapage.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Afrihost-Domain: lungprotectors.aserv.co.za
X-Afrihost-Username: 154.0.175.149
Authentication-Results: ucebox.co.za; auth=pass smtp.auth=154.0.175.149@lungprotectors.aserv.co.za
X-Afrihost-Outgoing-Class: unsure
X-Afrihost-Outgoing-Evidence: Combined (0.64)
X-Recommended-Action: accept
X-Filter-ID: Pt3MvcO5N4iKaDQ5O6lkdGlMVN6RH8bjRMzItlySaT8+Mf0RXYvCdEazpFWs75F2PUtbdvnXkggZ
 3YnVId/Y5jcf0yeVQAvfjHznO7+bT5yC8/hllkEO4eth1iSf0sYUt8C9mOBdONdnsxgsk1D2pw/C
 h5SE4jAyhe1COeASyU9jOZNZvMNHV+fjzEaL5oR94ld5rdi2ZxohSIq+dqifZuOZOVygByfHW+Y1
 QHFfZz9cO0jo5k2XI+QLxVOKjBL7+gaXrHkgRC7/tI3CjXmVypCxr40vathaqFJIQ7PWyN+iHDbX
 4trmKJMJeWRbEKxS4HOvw1sJZIcDSPsUZ3zBOK7VZqJmzCeHtqZ+QtMgTB0iLwRMaKsK8lAeAhb+
 aZDwCqOLSpypkmRfQl2WgK2CLZYIiHqfCgG4wrA3w4/kQTYKxDHA9JN9J4k4XZq11JQkMemT4rxn
 nByU11Ftkqf3f/PF3GUV+KdBBqrnCX8j0Gi8Ksk+aedMfNWSnJswrtlNhefER+C45dFg6YhhDdRT
 TvDhe5HUNc2CXYl0vrG/F5gksVlXZWxasRfFjM8m8h7IISdVKyA8/8yCpIYzH3apf78hv/eAPXF2
 /g6Nh7EU3uLgiMtsw3dCIn/K4AD+BQH+3X56iVOONvsse0yR1XZSIUXQVdWUYHU4VDiyLKCyVqQH
 mFDqewO9xyOqCYO8P1aHsjb0qc+GOwkR6nDgoC8XTe6PA3m8CvZ9AQ2DGE38qa9PvhkSot3yX0Uz
 6/z7iRxNXQqaNWd2HkKNqPfrt5YD3hnoIvqe0qzVdILfVj8UlwTGLQDibom0l33888VKzJAm4NM6
 C0ogzK0rRA5bt1qNnRxwEiTVJqDh0qKoKsXx5lktE/0pR1gcqnMo6qoc6bUypGGI7sBARgq/aXjV
 K9iJlwUD5/ofgrnFL13j7lDiq+RX5AiZPsg/m+U7byCxlI4RtXmlI+RaFzRG4QSytkwZhCZnQnAP
 QCjU3M8CrVIUtmYfxOAswMjag+ePdwxXbHq1PAw0qLjXjo90wAXBZr5m1m47LxgKeX7zGaDFhQBW
 OuIK0vQCifkhD5IgfFgo9nc9
X-Report-Abuse-To: spam@spe1.ucebox.co.za

Greetings from Bahrain Investors Group!

We understand the importance of securing funding for your projects. Based in Manama, Bahrain, we specialize in providing global financial services tailored to your needs. Our team of experienced Bahrain investors is well-equipped and ready to support your plans with the necessary capital.

We focus on offering flexible project funding options, including loans and debt financing in various currencies. Our terms are designed to ensure your satisfaction and financial stability, featuring:

    A twelve-month grace period
    Competitive interest rates
    Extended repayment terms

We highly value our partnerships with intermediaries and offer generous compensation for successful introductions to project owners.

Please share your loan requirements with us and let us demonstrate how we can assist in bringing your project to fruition. We are committed to seamlessly guiding you through the funding process.

Warm regards,

Faisal Al Rasbi
MEMBER, Bahrain Investors Group

