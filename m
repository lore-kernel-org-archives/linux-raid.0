From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v5 0/7] Partial Parity Log for MD RAID 5
Date: Thu, 9 Mar 2017 15:32:40 -0800
Message-ID: <20170309233240.r64itd7oreuxkumz@kernel.org>
References: <20170309090003.13298-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170309090003.13298-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 09, 2017 at 09:59:56AM +0100, Artur Paszkiewicz wrote:
> This series of patches implements the Partial Parity Log for RAID5 arrays. The
> purpose of this feature is closing the RAID 5 Write Hole. It is a solution
> alternative to the existing raid5-cache, but the logging workflow and much of
> the implementation is based on it.
> 
> The main differences compared to raid5-cache is that PPL is a distributed log -
> it is stored on array member drives in the metadata area and does not require a
> dedicated journaling drive. Write performance is reduced by up to 30%-40% but
> it scales with the number of drives in the array and the journaling drive does
> not become a bottleneck or a single point of failure. PPL does not protect from
> losing in-flight data, only from silent data corruption. More details about how
> the log works can be found in patches 3 and 5.
> 
> This feature originated from Intel RSTe, which uses IMSM metadata. PPL for IMSM
> is going to be included in RSTe implementations starting with upcoming Xeon
> platforms and Intel will continue supporting and maintaining it. This patchset
> implements PPL for external metadata (specifically IMSM) as well as native MD
> v1.x metadata.
> 
> Changes in mdadm are also required to make this fully usable. Patches for mdadm
> will be sent later.

Looks good, I'll apply this series into next. There are some small issues I
replied separately. Please send a separate patch to fix them if they make
sense, I'll integrate them locally.

Thanks,
Shaohua
