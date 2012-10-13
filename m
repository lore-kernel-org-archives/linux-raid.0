From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: RAID-6 problem
Date: Sat, 13 Oct 2012 11:45:10 -0700
Message-ID: <mepok9xf4q.ln2@goaway.wombat.san-francisco.ca.us>
References: <20121013120328.GA23279@lazy.lzy>
 <alpine.DEB.2.00.1210131919230.21297@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-10-13, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>
> Re-creating a raid5/6 with --assume-clean is for me a disaster recovery, 
> something that should be performed when everything else fails. It's 
> extremely unfortunate that a lot of guides bring this in very early in the 
> fault finding process.

Actually the RAID wiki suggests exactly this path, and suggests against
--force, contrary to the advice I've gotten here from Neil and others.

https://raid.wiki.kernel.org/index.php/RAID_Recovery#Restore_array_by_recreating_.28after_multiple_device_failure.29

I could update this, but not being expert all it'd say is "use
--assemble --force; if it fails ask on the mailing list."  :)  Perhaps
that's actually the best advice to give, but if there's something more
useful to put on that page maybe someone with more expertise could
update it?

--keith

-- 
kkeller@wombat.san-francisco.ca.us


