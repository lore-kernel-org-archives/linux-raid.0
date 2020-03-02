From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Linux 5.5 Breaks Raid1 on Device instead of Partition, Unusable
 I/O
Date: Mon, 2 Mar 2020 03:27:53 -0600
Message-ID: <9e31d56a-a35d-2413-b6c7-4a97445d487d@suddenlinkmail.com>
References: <e46b2ae7-3b88-05f2-58d7-94ee3df449e4@suddenlinkmail.com>
 <20200302102542.309e2d19@natsu>
 <920df583-1d9e-6037-1d61-cbd5e1133d4d@suddenlinkmail.com>
 <20200302115141.1e796b7c@natsu>
 <c5d8e6d2-a572-5602-6562-795ea52168ac@suddenlinkmail.com>
 <CAJCQCtTOJrvm7BnyqSSuCUa82ehZbtHgSGaQo1bzcepgdtazSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtTOJrvm7BnyqSSuCUa82ehZbtHgSGaQo1bzcepgdtazSw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/02/2020 01:08 AM, Chris Murphy wrote:
> smart also reports for /de/sdc
> 
>   40 53 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455
> 
> 
> So I'm suspicious of timeout mismatch as well.
> https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
> 
> 
> Chris Murphy
> 

The strace between the virtualbox host and guess show and number of I/O waits
that would seem to fit some timeout issue like that. But according to the
page, both drives in this array provide:

SCT capabilities:              (0x1085) SCT Status supported.

Which should be able to handle the correction without stumbling into the
timeout problem. Something is FUBAR. On a Archlinux guest running on that
array, At a text console when you type your user name and press [Enter], the
login may timeout before the password: prompt is ever displayed. So this is
really giving virtualbox fits.

On the host itself, you don't really notice much, other than a bit of slowdown
with readline and tab-completion every once in a while, but apps looking to
that array -- all bets are off.

And still not a single error in the journal or mailed from mdadm. You would
think if it was going to take 26 days to scrub a 3T array, some error should
pop up somewhere :-)

-- 
David C. Rankin, J.D.,P.E.
