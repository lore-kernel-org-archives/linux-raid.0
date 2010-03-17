From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Utility of IOATDMA for RAID5.
Date: Wed, 17 Mar 2010 11:48:40 -0700
Message-ID: <e9c3a7c21003171148r214c537es2e27fdf05a62c1a8@mail.gmail.com>
References: <201003112109.o2BL9eJB003728@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201003112109.o2BL9eJB003728@wind.enjellic.com>
Sender: linux-raid-owner@vger.kernel.org
To: greg@enjellic.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 11, 2010 at 2:09 PM,  <greg@enjellic.com> wrote:
> Hi Dan, hope this note finds your week going well.
>
> We are starting to bring Nehalem/XEON server motherboards which have
> the onboard DMA I/O offload support into our shop as part of our
> current purchasing round. =A0We have spun up a 2.6.32 kernel for test=
ing
> and have been able to load the modules etc.
>
> We use SCST to implement geographically isolated storage mirrors. =A0=
We
> primarily use RAID5 since our redundancy architecture gives us a bit
> of luxury which a single RAID5 implementation would not.
>
> If I understand things correctly your current work supports RAID6
> only. =A0Are there are any plans to support RAID5? =A0Or perhaps more
> correctly is there any utility to supporting RAID5 given the memory
> speeds and core counts which are now available?

Both raid5 and raid6 offload is supported by md and the ioatdma
driver.  However not all platforms have the raid offload capability.
This capability is enabled on the recently announced Jasper Forest[1]
platform.  On an enabled platform (with a 2.6.32 kernel and the
ioatdma driver loaded) the following command will display the presence
of xor and pq offload capabilities:

# cat /sys/class/dma/dma*/quickdata/cap
copy pq pq_val xor xor_val fill intr
copy pq pq_val xor xor_val fill intr
copy intr
copy intr
copy intr
copy intr
copy intr
copy intr

--
Dan

[1]: http://edc.intel.com/Platforms/Xeon-C5500-C3500-3420/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
