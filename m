Received: from sender-op-o10.zoho.eu (sender-op-o10.zoho.eu [136.143.169.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C799C
	for <linux-raid@vger.kernel.org>; Thu, 14 Dec 2023 06:18:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1702563491; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=W4XuenMwgw9NZtdfub776lspTb3HBTjkJth6oQ4mr6qDk29VK1D6djIK+ZQiKmef50YOhoLeZiKsb1QT+AFsJ4ohCyXWxSVeabidGeY5CCADraYdOqxai2TdI5DkfbS2vnmrwvsjXzvyvRpqo9m+9u0341vBLavrl31YjK0YvDs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1702563491; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0TLqI2A21OQ1cOFimBKXCD2gEdlxdRtNh9HmYKRk3BY=; 
	b=loa9PU4RixtsBAZUARnRrB5yIWJDqjo1WRoaGj7cb1cjR/r6ydOeoJCgTrGoYs5FLt8wHIxoVBcxK3OSW1LhhSgXcW77SMINc0eNi4G/78FFTFGdUY5ELAs2/0kykdfhKbG8/6Lxlz0hiWe3nskkOTp/FISZytRWp3y20luv8Zk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	spf=pass  smtp.mailfrom=jes@trained-monkey.org;
	dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.4.106] (85.184.187.58.dynamic.dhcp.aura-net.dk [85.184.187.58]) by mx.zoho.eu
	with SMTPS id 1702563489190819.094208613851; Thu, 14 Dec 2023 15:18:09 +0100 (CET)
Message-ID: <e5c7971f-a600-08ec-0f31-8f255bd99979@trained-monkey.org>
Date: Thu, 14 Dec 2023 09:18:07 -0500
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Song Liu <songliubraving@fb.com>, Coly Li <colyli@suse.de>,
 "Luse, Paul E" <paul.e.luse@intel.com>
From: Jes Sorensen <jes@trained-monkey.org>
Subject: Announcement: mdadm maintainer update
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

Hi

I wanted to let everyone know that Mariusz Tkaczyk is joining as mdadm
co-maintainer.

Anyone who has spent time on this list over the last couple of years
knows Mariusz as a serious and thorough patch reviewer and I believe he
will do a great job as co-maintainer. Most people will also have noticed
I have been struggling keeping up due to lack of time, especially since
mdadm is no longer directly linked to my daytime job. Having Mariusz
onboard should help us progress faster.

Thanks for stepping up Mariusz!

Jes
