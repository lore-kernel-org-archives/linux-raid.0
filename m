From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: RAID6 fallen apart
Date: Sun, 3 Sep 2006 18:19:13 +0300
Message-ID: <5b170a7d0609030819r402a2a36ob7e8b74195d16a5b@mail.gmail.com>
References: <87y7tcxu71.fsf@szonett.ki.iif.hu>
	 <17650.20238.346014.292009@cse.unsw.edu.au>
	 <87ejv027py.fsf@tac.ki.iif.hu>
	 <17651.40951.849657.876173@cse.unsw.edu.au>
	 <5b170a7d0609030818ra8fa45i8f45cb55a8628fc9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b170a7d0609030818ra8fa45i8f45cb55a8628fc9@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Ferenc Wagner <wferi@niif.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/3/06, Tuomas Leikola <tuomas.leikola@gmail.com> wrote:
> > Possibly safer to recreate with two missing if you aren't sure of the
> > order.  That way you can look in the array to see if it looks right,
> > or if you have to try a different order.
>
> I'd say it's safer to recreate with all disks, in order to get the
> resync. Otherwise you risk the all so famous silent data corruption on
> stripes with writes in-flight at the time of failure.

Ment to say: after you know the correct order. Sorry.

>
> Tuomas
>

-- 
VGER BF report: H 3.07213e-07
