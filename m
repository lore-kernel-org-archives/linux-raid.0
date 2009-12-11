From: Luca Berra <bluca@comedia.it>
Subject: Re: Combining OCFS2 with Linux software RAID-0?
Date: Fri, 11 Dec 2009 14:37:09 +0100
Message-ID: <20091211133709.GA8992@maude.comedia.it>
References: <23986fd90912091503r3c671448va4d8637edfab472b@mail.gmail.com> <20091210123703.71b47ce7@notabene.brown> <20091211071526.GA4062@maude.comedia.it> <20091211073002.311FDEA195C@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091211073002.311FDEA195C@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 11, 2009 at 08:30:02AM +0100, Wolfgang Denk wrote:
>Dear Luca Berra,
>
>In message <20091211071526.GA4062@maude.comedia.it> you wrote:
>>
>> While in similar setups, data protection should be handled by the
>> storage system, raid 1 has its uses in a failover setup with two sites.
>
>Would one not rather use something like DRBD for such a szenario? And
>OCFS2 on top of that?

it depends, if i have an high speed (i.e. FC) link between the two site
i might want to avoid the overhead, besides if we have more than one
node for site, would drbd work?

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
