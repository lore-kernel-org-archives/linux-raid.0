From: Adam Talbot <talbotx@comcast.net>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Sat, 24 Jun 2006 15:52:46 -0700
Message-ID: <449DC23E.4000604@comcast.net>
References: <449AEB7C.6040108@cjx.com>	<op.tblclqd3cigqcu@apollo13>	<fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com>	<449BE381.6070000@cjx.com>	<fd8d0180606230630x3f6b1ab7g444716cf8d5ab2c2@mail.gmail.com>	<68c491a60606230746m5c1f0301g8e00fdd4f0e0739b@mail.gmail.com>	<449C0505.8000601@tmr.com>	<fd8d0180606230834t18427168jd776d33980f516b2@mail.gmail.com> <17564.52087.651968.635043@cse.unsw.edu.au> <449CF0D0.9080006@comcast.net> <449D0715.8050609@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449D0715.8050609@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Neil Brown <neilb@suse.de>, Francois Barre <francois.barre@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Trying to test for tuning with different chunk's.  Just finished 16K
chunk and am about 20% done with the 32K test.  Here are the numbers on
16K chunk, will send 32, 96,128,192 and 256 as I get them.  But keep in
mind each one of these tests take about 4~6 hours, so it is a slow
process...  I have settled for XFS as the file system type, it seems to
be able to beat any thing else out there.
-Adam

XFS
Config=NAS+NFS
RAID6 16K chunk
nas tmp # time tar cf - . | (cd /data ; tar xf - )
real    252m40.143s
user    1m4.720s
sys     25m6.270s
/dev/md/0             1.1T  371G  748G  34% /data
4.207 hours @ 90,167M/hour or 1502M/min  or 25.05M/sec




David Greaves wrote:
> Adam Talbot wrote:
>   
>> OK, this topic I relay need to get in on.
>> I have spent the last few week bench marking my new 1.2TB, 6 disk, RAID6
>> array.
>>     
> Very interesting. Thanks.
>
> Did you get around to any 'tuning'.
> Things like raid chunk size, external logs for xfs, blockdev readahead
> on the underlying devices and the raid device?
>
> David
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

