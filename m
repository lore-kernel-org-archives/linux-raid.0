From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Why does one get mismatches?
Date: Wed, 24 Feb 2010 14:42:06 -0500
Message-ID: <4B85810E.6080801@tmr.com>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com><4B67451F.8040206@tmr.com> <20100202093738.44b4fece@notabene.brown><4B684087.50001@tmr.com> <20100211161444.7a0ea7bb@notabene.brown><20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu><4B7B0D45.7040801@tmr.com><6db64f7872286165ac1fd3436e9d6476@localhost><20100218100547.7aecdc34@notabene.brown><20100219151809.GB4995@lazy.lzy><20100220090208.06c1130f@notabene.brown><4B7F2013.4070905@shiftmail.org> <87k4u8zg3t.fsf@frosties.localdomain><4B7FC3A7.10104@shiftmail.org> <87iq9qu9j5.fsf@frosties.localdomain> <8754A21825504719B463AD9809E54349@m5>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8754A21825504719B463AD9809E54349@m5>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: 'Goswin von Brederlow' <goswin-v-b@web.de>, 'Asdo' <asdo@shiftmail.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy Watkins wrote:
> } open tempfile
> } write tempfile
> } raid1 starts to commit the block
> } write some more changing the block
> }  raid1 writes the 2nd copy of the block
> } delete file
> } fs never recommits the dirty page
> } 
> } Personally I don't really buy that scenario. At least not in the
> } frequency mismatches occur.
> } 
> } 
> } MfG
> }         Goswin
>
> If someone can map a mismatch to a file, the debate would be over.
>   

Simple test: create a three way raid-1. Run it on a heavily used ext3 
file system for a few days, until it has 3-4k mismatch count. Shut it 
down gracefully. Now
- run e2fsck -n on each of the parts, to prove the f/s is not corrupt
- mount on partition, using ext2 type, ro,noatime[1]
- do an md5sum on every file and put the output in a file[2]
  (on another f/s, obviously)
- mount each of the mirrors the same way
- run md5sum -C {saved_file} to check file content
If you get files which don't compare copy to copy you can see that the 
issue is real.

[1] rather than explain to newbies why neither changes to atime nor any 
journal activity doesn't make the file content change, I do it this way.
[2] MD5 is fine to detect file changes. You need sha1 or such only to 
detect malicious changes with intent to hide the change. Because it uses 
little CPU it's as good as any. Use sha256sum or similar if you doubt me.

Having had mismatches on raid-1 and not on raid-6 using the same three 
drives, I question the "hardware error" theory of mismatch origin.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

