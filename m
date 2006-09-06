From: Luca Berra <bluca@comedia.it>
Subject: Re: Care and feeding of RAID?
Date: Wed, 6 Sep 2006 20:49:45 +0200
Message-ID: <20060906184945.GD991@percy.comedia.it>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net> <44FD91D1.7090501@maine.edu> <20060905154156.GB28548@scavenger.homeip.net> <44FDC21C.7050203@maine.edu> <20060905205727.GD17634@percy.comedia.it> <20060906071224.GA20933@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060906071224.GA20933@scavenger.homeip.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 06, 2006 at 09:12:24AM +0200, Benjamin Schieder wrote:
>> >>Personally, I use this script from cron:
>> >>http://shellscripts.org/project/hdtest
>> 
>> nice race :)
>
>As in race condition? Where?

mktemp
rm
touch
why do you do that?

>I'm running smartmontools 5.33 here. When did the output change? It still
>works fine here.

i retested now with 5.36 and it seems the output did _not_ change, i
don't know what i saw this morning.

but then it errors on the line
IFS="   " read type status online < <( smartctl -d ata -a ${disk} | grep
\#\ 1 | sed 's,  \+,   ,g' | cut -f 2,3,5 )

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
