From: Asdo <asdo@shiftmail.org>
Subject: Re: Why does one get mismatches?
Date: Thu, 28 Jan 2010 11:29:57 +0100
Message-ID: <4B616725.3030500@shiftmail.org>
References: <802139.74942.qm@web51305.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <802139.74942.qm@web51305.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: Steven Haigh <netwiz@crc.id.au>, linux-raid@vger.kernel.org, Tirumala Reddy Marri <tmarri@amcc.com>
List-Id: linux-raid.ids

Jon Hardcastle wrote:
> Well, I finished running my none-destructive badblocks check and ran several smart --long tests I also did a forcefsk on the bad boy and NOW the active md4 (with a DEACTIVE vg on it) returns 0 mismatch_cnt. I haven't rebooted it in days though so I just dont know what casued this. No errors in the log, the pending/reallocated sector count is still 0 on all drives.
>
> I have reactivated my VG and am running it again now it is just bizzare.
>   


Very interesting!

I'm wondering what we can infer...
I'm thinking probably it was either a fault of the disks, fixed with 
smart --long tests, or a fault of the filesystem, fixed with forced fsck.
What do you think?

Tell us if mismatches start to happen again

Thank you
