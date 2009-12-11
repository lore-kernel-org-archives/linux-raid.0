From: Wolfgang Denk <wd@denx.de>
Subject: Re: Combining OCFS2 with Linux software RAID-0?
Date: Fri, 11 Dec 2009 08:30:02 +0100
Message-ID: <20091211073002.311FDEA195C@gemini.denx.de>
References: <23986fd90912091503r3c671448va4d8637edfab472b@mail.gmail.com> <20091210123703.71b47ce7@notabene.brown> <20091211071526.GA4062@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20091211071526.GA4062@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Luca Berra,

In message <20091211071526.GA4062@maude.comedia.it> you wrote:
>
> While in similar setups, data protection should be handled by the
> storage system, raid 1 has its uses in a failover setup with two sites.

Would one not rather use something like DRBD for such a szenario? And
OCFS2 on top of that?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Time is an illusion perpetrated by the manufacturers of space.
