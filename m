From: Turbo Fredriksson <turbo@bayour.com>
Subject: Re: linux-raid compatable w/ Adaptec AIC-7902?
Date: Mon, 04 Jul 2005 13:27:14 +0200
Message-ID: <87r7eex14d.fsf@pumba.bayour.com>
References: <200506300210.j5U2Acp04142@www.watkins-home.com>
	<200506301014.11454.eric@pretorious.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506301014.11454.eric@pretorious.net> (Eric Pretorious's
 message of "Thu, 30 Jun 2005 10:14:11 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Eric" == Eric Pretorious <eric@pretorious.net> writes:

    Eric> On Wednesday 29 June 2005 07:10 pm, Guy wrote:
    >>> md: delaying resync of md0 until md2 has finished resync (they
    >>> share one or more physical units) md: delaying resync of md1
    >>> until md2 has finished resync (they share one or more physical
    >>> units) ...
    >>> 
    >>> Should I be concerned by the last two lines?
    >> No, this is normal.  Your 3 arrays are on the same disk(s).  In
    >> this case, it is faster to do them 1 at a time.

    Eric> Oh - I get it: md can only work on one RAID at a time
    Eric> because md0, md1, & md2 are all on sda & sdb (i.e., sda is
    Eric> mirrored on sdb). Thanks!

I'm not DELIBERATELY trying to be rude here, but I want you to find the
answer yourself... :)

WHY are you putting multiple md's on the same disks? Did you intend to
do something like this?

   md0          /boot      sd[ab]1
   md1          /          sd[ab]2
   md2          /usr       sd[ab]3
   md3          /var       sd[ab]4

Just one question (this is the magic :). What do you gain by this? And
why do you do it?
-- 
Marxist Albanian quiche NSA critical FBI Honduras radar president
cracking assassination FSF cryptographic DES Mossad
[See http://www.aclu.org/echelonwatch/index.html for more about this]
