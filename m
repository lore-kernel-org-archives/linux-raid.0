From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Why does one get mismatches?
Date: Fri, 26 Feb 2010 22:01:13 -0800
Message-ID: <4877c76c1002262201h31051c44r9d756e4969a71fbb@mail.gmail.com>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
	 <6db64f7872286165ac1fd3436e9d6476@localhost>
	 <20100218100547.7aecdc34@notabene.brown>
	 <20100219151809.GB4995@lazy.lzy>
	 <20100220090208.06c1130f@notabene.brown> <4B853D99.1040902@tmr.com>
	 <20100225083748.42f024aa@notabene.brown> <4B8833BA.4010503@tmr.com>
	 <20100227080938.6540f041@notabene.brown>
	 <4B884930.1070205@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B884930.1070205@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Neil Brown <neilb@suse.de>, Bill Davidsen <davidsen@tmr.com>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@ehardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 26, 2010 at 2:20 PM, Asdo <asdo@shiftmail.org> wrote:
> Neil Brown wrote:
>>
>> Actually, I'm no longer convinced that the checksumming idea would w=
ork.
>> If a mem-mapped page were written, that the app is updating every
>> millisecond (i.e. less than the write latency), then every time a wr=
ite
>> completed the checksum would be different so we would have to resche=
dule
>> the
>> write, which would not be the correct behaviour at all.
>> So I think that the only way to address this in the md layer is to c=
opy
>> the data and write the copy. =A0There is already code to copy the da=
ta for
>> write-behind that could possible be leveraged to do a copy always.
>>
>
> The concerns of slowdowns with copy could be addressed by making the =
copy a
> runtime choice triggered by a sysctl interface, a file in /sys/block/=
mdX/md/
> interface where one can echo "1" to enable copies for this type of ra=
id. Or
> better 1 could be the default (slower but safer, or if not safer, at =
least
> to avoid needless questions on mismatches on this ML by new users, an=
d to
> allow detection of REAL mismatches which can be due to cabling or def=
ective
> disks) and echoing 0 would increase performances at the cost of seein=
g lots
> of false positive mismatches.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Isn't there some way of making the page copy-on-write using hardware
and/or an in-kernel structure?  Ideally copying could be avoided
/unless/ there is change.  That way each operation looks like an
atomic commit.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
