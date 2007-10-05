From: Brendan Conoboy <blc@redhat.com>
Subject: Re: RAID 5 performance issue.
Date: Fri, 05 Oct 2007 14:25:29 -0600
Message-ID: <47069DB9.2050608@redhat.com>
References: <20071003105321.06943824@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071003105321.06943824@zeus.pccl.info>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Clayton <andrew@pccl.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Clayton wrote:
> If anyone has any idea's I'm all ears.

Hi Andrew,

Are you sure your drives are healthy?  Try benchmarking each drive 
individually and see if there is a dramatic performance difference 
between any of them.  One failing drive can slow down an entire array. 
  Only after you have determined that your drives are healthy when 
accessed individually are combined results particularly meaningful.  For 
a generic SATA 1 drive you should expect a sustained raw read or write 
in excess of 45 MB/s.  Check both read and write (this will destroy 
data) and make sure your cache is clear prior to the read test and after 
the write test.  If each drive is working at a reasonable rate 
individually, you're ready to move on.

The next question is: What happens when you access more than one device 
at the same time?  You should either get nearly full combined 
performance, max out CPU, or get throttled by bus bandwidth (An actual 
kernel bug could also come into play here, but I tend to doubt it).  Is 
the onboard SATA controller real SATA or just an ATA-SATA converter?  If 
the latter, you're going to have trouble getting faster performance than 
any one disk can give you at a time.  The output of 'lspci' should tell 
you if the onboard SATA controller is on its own bus or sharing space 
with some other device.  Pasting the output here would be useful.

Assuming you get good performance out of all 3 drives at the same time, 
it's time to create a RAID 5 md device with the three, make sure your 
parity is done building, then benchmark that.  It's going to be slower 
to write and a bit slower to read (especially if your CPU is maxed out), 
but that is normal.

Assuming you get good performance out of your md device, it's time to 
put your filesystem on the md device and benchmark that.  If you use 
ext3, remember to set the stride parameter per the raid howto.  I am 
unfamiliar with other fs/md interactions, so be sure to check.

If you're actually maxing out your bus bandwidth and the onboard sata 
controller is on a different bus than the pci sata controller, try 
balancing the drives between the two to get a larger combined pipe.

Good luck,

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
