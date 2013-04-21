From: Ben Bucksch <linux.news@bucksch.org>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Sun, 21 Apr 2013 10:20:41 +0200
Message-ID: <5173A159.70202@bucksch.org>
References: <516869D2.9030506@bucksch.org> <516B3077.9020507@schinagl.nl> <516B590C.5060807@bucksch.org> <516AE7A0.4070504@schinagl.nl> <516BD5E0.4040007@bucksch.org> <516FF25B.4000907@bucksch.org> <516FFC13.2030803@ultratux.net> <5171CB91.1040708@bucksch.org> <5171EED3.8030505@bucksch.org> <5171F52D.4040701@bucksch.org> <51739405.1060805@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51739405.1060805@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell wrote, On 21.04.2013 09:23:
> As others have already told you, md does not go randomly kicking 
> drives from arrays. Your system had a failure of some kind which 
> caused the loss of two drives.

You ignore the facts and do "mi mi mi" in face of bugs reports. 2 
different arrays lost 1 drive, both at the same time at reboot after the 
OS upgrade, and both drives are working fine. Facts.

And even *if* they had a temporary error, my case shows why it's a *bug* 
to kick them out of the array. And it's a *bug* to not let me put them 
back in with data. Tons of other people have suffered dataloss because 
of various temporary, easily recoverable problems and these 2 bugs.

People like you are the reason why people like me suffer dataloss.
