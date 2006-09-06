From: Luca Berra <bluca@comedia.it>
Subject: Re: Care and feeding of RAID?
Date: Wed, 6 Sep 2006 09:16:09 +0200
Message-ID: <20060906071609.GF17634@percy.comedia.it>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net> <44FD91D1.7090501@maine.edu> <20060905154156.GB28548@scavenger.homeip.net> <44FDC21C.7050203@maine.edu> <20060905205727.GD17634@percy.comedia.it> <44FDF08D.8000504@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44FDF08D.8000504@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 05, 2006 at 05:47:57PM -0400, Steve Cousins wrote:
>
>
>Luca Berra wrote:
>
>>On Tue, Sep 05, 2006 at 02:29:48PM -0400, Steve Cousins wrote:
>>
>>>
>>>
>>>Benjamin Schieder wrote:
>>>
>>>>On 05.09.2006 11:03:45, Steve Cousins wrote:
>>>>
>>>>>Would people be willing to list their setup? Including such things 
>>>>>as mdadm.conf file, crontab -l, plus scripts that they use to check 
>>>>>the smart data and the array, mdadm daemon parameters and anything 
>>>>>else that is relevant to checking and maintaining an array? 
>>>>
>>>>
>>>>
>>>>Personally, I use this script from cron:
>>>>http://shellscripts.org/project/hdtest
>>
>>
>>nice race :)
>
>I'm not sure what you mean?

tmp="`mktemp`"
rm -f ${tmp}
touch ${tmp}

the last two lines are unneeded and can be tricked to overwrite
arbitrary filenames


>I tried smartctl -t short -d scsi /dev/sdb where /dev/sdb is a 250GB 
>SATA drive.

it is '-d ata'

>What command do you use for SATA drives?  The sourceforge page implies 
>that -d sata doesn't exist yet.  I'm using FC 5 with 2.6.17 kernel and 
>smartmontools version 5.33.  Do you have a sample configuration script 
>that you could show me?

# monitor two sata disks, show temperature in degrees,
# do a long test every sunday and a short every other day
# at 1am on sda and at 2am on sdb, YMMV
/dev/sda -d ata -a -R 194 -s (L/../../7|S/../../[123456])/01
/dev/sdb -d ata -a -R 194 -s (L/../../7|S/../../[123456])/02

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
