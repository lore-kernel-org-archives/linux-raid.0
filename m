From: Brad Campbell <brad@wasp.net.au>
Subject: Re: libata badness
Date: Tue, 05 Oct 2004 08:49:37 +0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <416227E1.8020306@wasp.net.au>
References: <Pine.LNX.4.60-041.0410040656001.2350@unix48.andrew.cmu.edu> <16737.54003.419130.575839@cse.unsw.edu.au> <Pine.LNX.4.60-041.0410042301510.22333@unix47.andrew.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.60-041.0410042301510.22333@unix47.andrew.cmu.edu>
To: William Knop <wknop@andrew.cmu.edu>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

William Knop wrote:
> 
>> This code starts:
>>
>>   0:   8b 55 04                  mov    0x4(%ebp),%edx
>>   3:   83 c1 08                  add    $0x8,%ecx
>>
>> and as %ebp is 01000000, this oopses.
>> It looks very much like a single-bit memory error (as has already been
>> suggested as a possibility).
> 
> 
> Oh my. So, I ran memcheck again for a few hours, and it checked out 
> fine. Just in case, though, I bought a replacement stick of ram. Well, 
> the oopses went away, so it must have been the ram.

For future reference, I have had errors show up after 24-36 hours of memtest86. I usually find that 
if it passes 48 hours of testing then things are looking pretty reliable. A couple of hours is 
usually too small a sample to rely on.

Brad
