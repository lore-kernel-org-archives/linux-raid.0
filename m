From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: possible bug using async_xor() call in ops_run_post_xor()
Date: Fri, 25 Jul 2008 12:47:27 -0700
Message-ID: <e9c3a7c20807251247u394dc31r1a378d10c947946f@mail.gmail.com>
References: <833724.76277.qm@web81303.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <833724.76277.qm@web81303.mail.mud.yahoo.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 25, 2008 at 11:45 AM, tirumalareddy marri
<tirumalareddymarri@yahoo.com> wrote:
> I am looking at async_xor() usage and found that if async_xor() returns null because of  device->device_prep_dma_xor() <async_xor.c> failed to get slot. This might cause failure of stripe creation . Which would cause data corruption in RAID-5 at high data rates.
> OR
> Data integrity is guaranteed because ops_complete_write() will not be called in the event of  device->device_prep_dma_xor() failed to get slot and returned NULL ?

Hi Marri,

ops_complete_write will be called regardless of whether NULL is
returned.  If async_xor returns NULL it simply indicates to the caller
that the operation was completed synchronously.  In current mainline
async_xor will poll for a descriptor so the driver must take care to
ensure forward progress.

--
Dan
