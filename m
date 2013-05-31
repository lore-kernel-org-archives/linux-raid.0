From: Dominic Raferd <dominic@timedicer.co.uk>
Subject: Re: SSD + Rust as raid1
Date: Fri, 31 May 2013 09:52:49 +0100
Message-ID: <51A864E1.9070903@timedicer.co.uk>
References: <51A7C36F.4030605@timedicer.co.uk> <20130531133018.77cd9285@natsu> <51A85574.8080709@timedicer.co.uk> <20130531135434.5b6bdddb@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130531135434.5b6bdddb@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/05/2013 08:54, Roman Mamedov wrote:
> On Fri, 31 May 2013 08:47:00 +0100
> Dominic Raferd <dominic@timedicer.co.uk> wrote:
>
>> This is my idea too (see my OP), but I am concerned about optimisation
>> (--write-behind, --bitmap and --bitmap-chunk settings) especially for
>> writes.
>> --write-behind=16384
> I think this will not work, you will have to use 16383.

Oh, OK, so 16383 is the maximum then?

>> --bitmap=/mnt/sda1/write-intent-bitmap.file
> Save yourself lots of maintenance headache, just use --bitmap=internal
>
>> --bitmap-chunk=256M
> Looks OK.
>

Thanks Roman, but the problem with using --bitmap=internal is that, as 
Neil Brown posted here on another topic a while ago, this requires a 
synch write to both devices, and the use-case for which write-behind was 
developed involved an external bitmap. Hence my plan to use external 
bitmap file on a fast (SSD-based) separate partition - minimises any 
slow-down caused by having to maintain the write-intent bitmap file.
