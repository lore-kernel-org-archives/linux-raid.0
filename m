From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: meta: should i chase this down?
Date: Mon, 12 Dec 2011 13:13:34 -0800
Message-ID: <uc7ir8xk6i.ln2@goaway.wombat.san-francisco.ca.us>
References: <42n2r8xe3k.ln2@goaway.wombat.san-francisco.ca.us>
 <20111207114726.2f3f3543@notabene.brown>
 <5973r8xg7n.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

On 2011-12-07, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
>
> I do have some drive bays that I should be able to free up, and I think
> that I have some free disks lying around I can use, which I think should
> replicate a more real-life scenario.

Just a short followup: I've yet to be able to replicate the kernel
crash.  I added some 400GB disks, split them into two 200GB partitions
each, built a 4-part RAID6, added a fifth partition and started a
reshape, then started some disk IO (both reads and writes).  So far,
nothing bad has happened, even with a bad disk in the mix (though
perhaps that's masking the issue in a bizarre way).

I may make another attempt using one partition on all the disks instead
of two, but I'm not terribly optimistic that this will result in the
crash.  So I am afraid that my likeliest next step is to watch the next
time I need to grow the ''real'' RAID6 where this happened the first
time.  At least this time I will have netconsole working if it does
happen again, and will be able to make a more informed report.

--keith


-- 
kkeller@wombat.san-francisco.ca.us

