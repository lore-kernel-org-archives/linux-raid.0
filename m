From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: behavior different from mdadm 2.6.4 and 3.0?
Date: Mon, 15 Dec 2008 20:35:08 -0600
Message-ID: <cccedfc60812151835xb3a1442u4f344c26df075888@mail.gmail.com>
References: <cccedfc60812150654u2e841bf8na517a75820d0c463@mail.gmail.com>
	 <18758.51222.370545.686154@notabene.brown>
	 <cccedfc60812151335u3d08dc6bid79bae8c88a62133@mail.gmail.com>
	 <18759.1035.627538.450310@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18759.1035.627538.450310@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 15, 2008 at 7:27 PM, Neil Brown
> That's the problem then.
> The array was started from initrd and any mdadm/map that was created
> would have got lost.
> Now it needs one to continue with assembly and cannot find one.
> I'll have to get it to do the "-Ir" thing automagically if mdadm/map
> does not exist.

>> Does that help?
>
> So: yes it does - thanks.

Awesome!

> I've got some coding to do ;-)

I'm sorry to be causing you more work.

-- 
Jon
