Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=strugglers.net header.i=@strugglers.net header.b="VETu5hMm"
X-Greylist: delayed 1061 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 26 Nov 2023 02:55:29 PST
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC4EDE
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 02:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=strugglers.net; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References
	:Message-ID:Subject:To:From:Date:Content-Transfer-Encoding:Sender:Reply-To:Cc
	:Content-ID:Content-Description:Resent-To;
	bh=LcJsC4KH4Kv9CFTyGY5hogR+dFjWJpc+/azJv5eusBw=; b=VETu5hMmgsYd7hY9BkYEN9RtoQ
	yXlzmLP0ZO6M5hrBhuUlMzWD4fJVpdQ4oYL0KkCCHu2QazsEse1CTLIMc0vxvXiY9yovSnF1Fqtnb
	c6gKYAUGyJKp2WWmzHHCUbWuDZZwPjaS8/A9o1hQTbJ3oXvE2nPICIQE7p0HxHIfRVY3/5VnxQbJz
	2etLk4VCqCfTAuFV9c3gZuexQigC5mcMWHWOBoZ7K9hnhipcc8gdHkFkP6vK2M/Tg6zRm+bX0B6O6
	8hpJCjftjBHEwPK1HAbInkwFtsUGs44ntGa+Ho6Lpmc6g52CjrfwT3tRX8eDQw1ONZSJ8Zsff7p8C
	Luoj2Mww==;
Received: from andy by mail.bitfolk.com with local (Exim 4.94.2)
	(envelope-from <andy@strugglers.net>)
	id 1r7CWI-0002Kq-NN
	for linux-raid@vger.kernel.org; Sun, 26 Nov 2023 10:37:46 +0000
Date: Sun, 26 Nov 2023 10:37:46 +0000
From: Andy Smith <andy@strugglers.net>
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Subject: Re: SMR or SSD disks?
Message-ID: <ZWMf+lg/CgRlxKtb@mail.bitfolk.com>
Mail-Followup-To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXh-FB0HaCJGFKHHgzaSqh+cQefPsK45Y_UBTsrcxaa6ww@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJH6TXh-FB0HaCJGFKHHgzaSqh+cQefPsK45Y_UBTsrcxaa6ww@mail.gmail.com>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL: http://strugglers.net/wiki/User:Andy
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false

Hello,

On Sun, Nov 26, 2023 at 11:18:39AM +0100, Gandalf Corvotempesta wrote:
> i'm doing some maintenance replacing some not-yet-failed HDD with WD RED SSD.
> I've read the warning on the homepage
> https://raid.wiki.kernel.org/index.php/Linux_Raid
> 
> Are SSD drives still subject to SMR ? I've thought that it was related
> only to magnetic drives not on SSD.

SMR is not applicable to flash-based storage. I expect the warning
on the wiki was written at a time when the only drives bearing the
WD Red brand were HDDs, not any SSDs.

Thanks,
Andy
