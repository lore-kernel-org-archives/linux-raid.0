From: Tim Small <tim@seoss.co.uk>
Subject: Re: raid 5 mismatch_cnt errors
Date: Mon, 24 May 2010 10:34:28 +0100
Message-ID: <4BFA4824.10107@seoss.co.uk>
References: <4BF56B1F.9080205@locallinux.com> <20100521071645.497cdcad@notabene.brown> <4BF5B7D1.3070808@locallinux.com> <20100521083819.54680dfb@notabene.brown> <4BF5ECE7.7020907@redhat.com> <4BF6B782.3060408@shiftmail.org> <4BF6F3B9.5020405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4BF6F3B9.5020405@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: MRK <mrk@shiftmail.org>, Neil Brown <neilb@suse.de>, Trey Scarborough <treys@locallinux.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On 21/05/10 21:57, Doug Ledford wrote:
> On 05/21/2010 12:40 PM, MRK wrote:
>    
>> On 05/21/2010 04:16 AM, Doug Ledford wrote:
>>      
>> Could the cabling to the drive be causing this? (maybe failing or maybe
>> it's partly disconnected)
>> I don't remember at what point Linux is at implementing the checksums
>> between the controller and the drive.
>>      
> I don't know.  I'm not up on the SATA signaling details so I don't know
> if it uses CRC on the signal, but I suspect it does and a bad cable
> would cause failed requests.  But I wouldn't bet my house on it, so I
> would ask some SATA gurus.
>    

I wouldn't call myself that, but I believe PATA and SATA-level CRC 
errors show up in the UDMA_CRC_Error_Count SMART variable - look for a 
non-zero raw value in the smartctl output.  This is presumably just the 
error-count from the drive's point of view (bad data recd at drive 
end).  I don't know what happens with CRC errors detected at the Linux 
end - and whether detection is controller-dependant.  Better ask on 
linux-ide.


 From the SMART attribute name, presumably the earlier PATA transfer 
modes don't support CRC error detection.

An easy thing to check might be to reduce the libata transfer speed from 
3GBps to 1.5GBps.  Similarly, try to test each drive and SATA port in 
isolation if you can....

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

