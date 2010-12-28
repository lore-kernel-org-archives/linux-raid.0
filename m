From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: md-raid and block sizes
Date: Tue, 28 Dec 2010 11:45:15 +0000
Message-ID: <4D19CDCB.4090208@anonymous.org.uk>
References: <1293451228.3266.9.camel@Waves.darkmere> <AANLkTim_vvdzYpdgQitK0942h-cW-q14MLhooSoaBOeL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim_vvdzYpdgQitK0942h-cW-q14MLhooSoaBOeL@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/12/2010 19:02, Doug Dumitru wrote:
[...]
> The same rules apply to most SSDs.  Most SSDs prefer 4K alignment
> because of how the FTL (Flash Translation Layers) operate, even though
> <4K will sometimes still work pretty well.

If I remember correctly, it may be better to align on SSDs at a larger 
granularity, to the SSDs' erase block size, which may be up to 512K 
depending on the SSD, though I don't remember at all how well Linux 
filesystems, VFS, block layer drivers etc. handle SSD TRIM etc.

Cheers,

John.

