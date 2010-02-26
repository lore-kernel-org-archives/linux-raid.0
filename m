From: Asdo <asdo@shiftmail.org>
Subject: Re: Why does one get mismatches?
Date: Fri, 26 Feb 2010 23:20:32 +0100
Message-ID: <4B884930.1070205@shiftmail.org>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
 <4B67451F.8040206@tmr.com> <20100202093738.44b4fece@notabene.brown>
 <4B684087.50001@tmr.com> <20100211161444.7a0ea7bb@notabene.brown>
 <20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu> <4B7B0D45.7040801@tmr.com>
 <6db64f7872286165ac1fd3436e9d6476@localhost>
 <20100218100547.7aecdc34@notabene.brown> <20100219151809.GB4995@lazy.lzy>
 <20100220090208.06c1130f@notabene.brown> <4B853D99.1040902@tmr.com>
 <20100225083748.42f024aa@notabene.brown> <4B8833BA.4010503@tmr.com>
 <20100227080938.6540f041@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20100227080938.6540f041@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> Actually, I'm no longer convinced that the checksumming idea would work.
> If a mem-mapped page were written, that the app is updating every
> millisecond (i.e. less than the write latency), then every time a write
> completed the checksum would be different so we would have to reschedule the
> write, which would not be the correct behaviour at all.
> So I think that the only way to address this in the md layer is to copy
> the data and write the copy.  There is already code to copy the data for
> write-behind that could possible be leveraged to do a copy always.
>   
The concerns of slowdowns with copy could be addressed by making the 
copy a runtime choice triggered by a sysctl interface, a file in 
/sys/block/mdX/md/ interface where one can echo "1" to enable copies for 
this type of raid. Or better 1 could be the default (slower but safer, 
or if not safer, at least to avoid needless questions on mismatches on 
this ML by new users, and to allow detection of REAL mismatches which 
can be due to cabling or defective disks) and echoing 0 would increase 
performances at the cost of seeing lots of false positive mismatches.
