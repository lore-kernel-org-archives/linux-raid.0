From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: On URE and RAID rebuild - again!
Date: Sat, 02 Aug 2014 18:21:07 +0200
Message-ID: <1370eb7a35b628323646a86094a26912@assyoma.it>
References: "<53D8ACF0.1070202@assyoma.it>	<alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>"
 <53D8ED99.90606@assyoma.it> <20140731073121.38cd1773@notabene.brown>
 <53D9ED48.9000307@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53D9ED48.9000307@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids

Hi again,
I started a little experiment regarding BER/UREs and I wish to have an 
informed feedback.

As I had a spare 500 GB Seagate Barracuda 7200.12 (BER 10^14 max: 
http://www.seagate.com/staticfiles/support/disc/manuals/desktop/Barracuda%207200.12/100529369e.pdf), 
I started to read it continuously with the following shell command: dd 
if=/dev/sdb of=/dev/null bs=8M iflag=direct

The drive was used as a member of a RAID10 set on one of my test 
machines, so I assume its platters are full of pseudo-random data. At 
100 MB/s, I am now at about 15 TB read from it and I don't see any 
problem reported by the kernel.

Some questions:
1) I should try in different / harder mode to generate UREs? Maybe using 
some pre-determined pseudo-random string and then comparing the results 
(I think this is more appropriate to catch silent data corruption, by 
the way)?
2) how UREs should be visible? Via error reporting through dmesg?

Thanks.

Il 2014-07-31 09:16 Gionatan Danti ha scritto:
>> Yes, you can usually get your data back with mdadm.
>> 
>> With latest code, a URE during recovery will cause a bad-block to be 
>> recorded
>> on the recovered device, and recovery will continue.  You end up with 
>> a
>> working array that has a few unreadable blocks on it.
>> 
>> NeilBrown
> 
> This is very good news :)
> I case of parity RAID I assume the entire stripe is marked as bad, but
> with mirror (eg: RAID10) only a single block (often 512B) is marked
> bad on the recovered device, right?
> 
> From what mdadm/kernel version the new behavior is implemented? Maybe
> the software RAID on my CentOS 6.5 is stronger then expected ;)
> 
> Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
