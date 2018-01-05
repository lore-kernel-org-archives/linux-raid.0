From: Alexander Shenkin <al@shenkin.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Fri, 5 Jan 2018 14:01:30 +0000
Message-ID: <5c351837-10c3-1b1e-56f0-aef143289505@shenkin.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <a5487193-24e6-879b-bd09-caf5f75c8fcc@turmel.org>
 <05e4489d-98ea-4d12-02d6-f13a98e3d5d4@shenkin.org>
 <201ea04e-1a03-fc83-c31c-146b50bb8624@thelounge.net>
 <47ec07c3-25ae-9595-78a2-8420c106f2a0@fnarfbargle.com>
 <20497c70-140d-c4dd-0201-816477bd467f@shenkin.org>
 <14f1fce1-2959-e051-f7c8-1d98951d744a@fnarfbargle.com>
 <07170cf8-d951-013b-7e67-eee54aa60c65@shenkin.org>
 <61e91b55-5b96-143e-15c8-4a320f89eeb2@turmel.org>
 <ae183814-248b-2d45-8074-85787fcd0d61@shenkin.org>
 <6572ed42-8559-84eb-0468-7823786c3001@turmel.org>
 <7bce6228-0695-ff30-7cc0-60486be128ff@shenkin.org>
 <c24ffbc6-6ba6-ef04-76f3-2217fe5f4926@shenkin.org>
 <97c75be5-1988-0e66-0d50-f06188418b3b@fnarfbargle.com>
 <cd34964a-e269-6dd7-3c36-73a9c8dbb61d@shenkin.org>
 <bc2e597b-1585-f9b6-ef1a-f1aa3e1f39a0@fnarfbargle.com>
 <85891f3d-eaf6-9127-b55a-dea9d21d180b@fnarfbargle.com>
 <35f51be7-7dbd-88f8-e743-3976bef51de2@shenkin.org>
 <6b7ed6c2-497a-2b8d-4cd4-d7a8620bba75@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6b7ed6c2-497a-2b8d-4cd4-d7a8620bba75@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Brad Campbell <brad@fnarfbargle.com>, Reindl Harald <h.reindl@thelounge.net>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/5/2018 1:50 PM, Phil Turmel wrote:
> No. Parity is interleaved with data on all devices, chunk by chunk, on
> all default raid5/6 layouts.

Thanks Phil.  So, I suppose then the final diagnosis of my issue was 
that the bad sector occurred in a non-raid portion of the drive, which 
is why it was never read from or written to, and hence never corrected.

BTW, my reallocated sector count remains at 0 on that drive, but 
whatever - maybe that's because there was no data to reallocate (though 
i would think it would physically reallocate some sectors regardless). 
Also, I keep getting Rebuild99 events on /dev/md0.  But, I think that, 
when I have time, I'll add a drive for raid6, fail out sda, write it 
with 0's, update it's firmware (apparently seagate released one for 
these drives), and re-add it.

Thanks,
allie
