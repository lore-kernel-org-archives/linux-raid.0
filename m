From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v4 0/7] Partial Parity Log for MD RAID 5
Date: Mon, 27 Feb 2017 17:35:04 -0800
Message-ID: <20170228013504.5zlzaaxsvboow6hj@kernel.org>
References: <20170221194401.18733-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170221194401.18733-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 21, 2017 at 08:43:54PM +0100, Artur Paszkiewicz wrote:
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
> This feature originated from Intel RSTe, which uses IMSM metadata. This
> patchset implements PPL for external metadata (specifically IMSM) as well as
> native MD v1.x metadata.
> 
> Changes in mdadm are also required to make this fully usable. Patches for mdadm
> will be sent later.

Generally looks ok, I replied separatly. I'd like to make sure the new format
will be supported by Intel RSTe, and intel will continue working on this.

Thanks,
Shaohua
