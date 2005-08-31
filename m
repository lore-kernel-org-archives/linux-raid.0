From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: 2 partition kicked from 6 raid5
Date: Wed, 31 Aug 2005 23:32:26 +0400
Message-ID: <431605CA.3010705@tls.msk.ru>
References: <20050830181015.GA24181@koli.kando.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050830181015.GA24181@koli.kando.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Deak Krisztian <dechris@koli.kando.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Deak Krisztian wrote:
> Hi,
> 
> i have a big problem. A had a sw raid5 array with 6 partition. The array
> has been damaged because problems of power connectors. 2 partitions/disks don't work,
> because during the time the SATA power connections didn't work. 
> Some write/read operations where running. Now when i want to
> run the array loading the kernel, i get the next message:
> 
> raid5: device sdl1 operational as raid disk 0
> raid5: device sdj1 operational as raid disk 5
> raid5: device sdh1 operational as raid disk 3
> raid5: device sdg1 operational as raid disk 2
> raid5: not enough operational devices for md0 (2/6 failed)

Are you using raid autostart (in-kernel auto-activating of raid
arrays) or bring it up using mdadm?  If the latter, try adding
--run option.  If the former, your only choice is to use some
rescue CD or something, and again, to try this same mdadm --run...

Depending on where/how you got to this state, your data may
be just fine.

/mjt
