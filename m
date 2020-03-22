From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid6 recovery
Date: Sat, 21 Mar 2020 20:32:50 -0400
Message-ID: <50fc13d2-bd5f-d3c3-09f6-f7274aeaf917@turmel.org>
References: <CA+9eyijuUEJ7Y8BuxkKaZ=v8zbPpwixOezngPjtJzaLsBd+A4Q@mail.gmail.com>
 <5E75163B.2050602@youngman.org.uk>
 <CA+9eyigMV-E=FwtXDWZszSsV6JOxxFOFVh6WzmeH=OC3heMUHw@mail.gmail.com>
 <ab2a40b6-b4ab-9ff8-aef6-02d8cce8d587@youngman.org.uk>
 <CA+9eyig8U2Tzi1wF97k7eDu5vKg5Jc2sRXKaw0OCy7Cbc9HMog@mail.gmail.com>
 <c55be05d-22ee-4676-7878-5bf99ccc80f9@turmel.org>
 <CA+9eyiicKrPh9YTrGN5FjOU7zMVMqO3=8yGszWkV67fJxrtKrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+9eyiicKrPh9YTrGN5FjOU7zMVMqO3=8yGszWkV67fJxrtKrw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Glenn Greibesland <glenngreibesland@gmail.com>
Cc: antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 3/21/20 6:12 PM, Glenn Greibesland wrote:

[trim /]

> So to summarize what happened and what I've learned:
> I had a RAID6 array with only 16 out of 18 working drives.
> I received an email from mdadm saying another drive failed.
> I ran a full offline smart test that completed successfuly.
> 
> The drive was in F (failed) state. I used --re-add and mdadm overwrote
> the superblock turning it into a spare drive instead of putting the
> drive back into slot 10.
> I should have used --assemble --force.
> 
> Am I correct?

Yes.

However, there have been bugs in --force that would cause it to not 
assemble.  Also, I believe latest behavior for --re-add would not have 
damaged the metadata.


Phil
