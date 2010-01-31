From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster
 !!
Date: Sun, 31 Jan 2010 11:45:55 +0100
Message-ID: <4B655F63.2000705@texsoft.it>
References: <4B5F6C73.30707@texsoft.it> <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene> <4B647E0E.6050609@texsoft.it> <4B64A779.6070809@shiftmail.org> <4B64B0C1.1040503@texsoft.it> <4B64DB75.70607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B64DB75.70607@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> I have never seen a properly good disk that gets that high of error 
> rate actually exposed to the OS.  I have dealt with >5000 disk for 
> several years of history on the 5000+ disks.
I have experience with not so many disks, but I was used that they are 
quite reliable, and that the first read error reported to OS is symptom 
of an incominc failure; I always replaced them in such case, and this is 
why I am so amazed that kernel 2.6.15 changed the way it manages read 
errors (as also Asdo said, it's ok for raid-6, but unsafe for raid-5, 1, 
4, 10).

Actually I had not a single read error since 2-3 years on my systems, 
but now ... in a week, I had 4 disk failed (yes... another one since I 
started this thread!!) ... it's 30% of the total disks in my systems ... 
so I'm really puzzled out ... I don't know what to trust ... I'm just in 
the hands of God
> Nothing in the error rate indicated that behavior, so if you get a bad 
> lot it will be very bad, if you don't get a bad lot you very likely 
> won't have issues.   Now including the bad lots data into the overall 
> error rate, may result in the error rate being that high, but you luck 
> will depend on if you have a good or bad lot.
My disks are form same manufacturer as size, but different lot, as 
bought in different times, and different models.
Systems are well protected by UPS and in different places!
 ... my unluky week .. or I have a big EM storm over here...
I've recall to duty old 120G disks to save some data.

Cheers

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


