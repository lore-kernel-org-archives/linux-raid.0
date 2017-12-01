From: Michael Lyle <mlyle@lyle.org>
Subject: =?UTF-8?B?UmU6IOWbnuWkje+8muWbnuWkje+8mltQQVRDSF0gYmNhY2hlOiBGaXgg?=
 =?UTF-8?Q?bdev_leak_during_backing_device_registering?=
Date: Thu, 30 Nov 2017 18:13:55 -0800
Message-ID: <8e876c3b-c1e6-c281-04e6-b9467a0d25a7@lyle.org>
References: <fd806bd1-6537-42a7-8af3-d8dee9cb8fb9.liangyan.ply@alibaba-inc.com>
 <77a964ce-696e-4736-8dd9-c23969c7b567.liangyan.ply@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <77a964ce-696e-4736-8dd9-c23969c7b567.liangyan.ply@alibaba-inc.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: =?UTF-8?B?5b2t6Imv5b2m?= <liangyan.ply@alibaba-inc.com>, linux-bcache <linux-bcache@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Coly Li <colyli@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?5Y2V5Zu95paHKOa4oeazoik=?= <dubo.sgw@alibaba-inc.com>, =?UTF-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@alibaba-inc.com>
List-Id: linux-raid.ids

On 11/30/2017 05:54 PM, 彭良彦 wrote:

> Here is the issue reproduce step.
> 1. create a block device sdb by iSCSI
> 2. echo /dev/sdb > /sys/fs/bcache/register and succeed to register //sdb is the block dev create by iSCSI
> 3. disconnect network and reboot  // without network, SET_BDEV_STATE(&dc->sb, BDEV_STATE_NONE) will fail
> 4. create a block device sdb by iSCSI
> 5. echo /dev/sdb > /sys/fs/bcache/register and fail to register since bdev state is not reset to BDEV_STATE_NONE
> 6. make-bcache -B /dev/sdb --writeback --wipe-bcache
> the last step will fail in original version since bdev handle is not released during register and open() is failed in make-bcache, with this patch, it will succeed

But it is supposed to fail / wait in this case, if the cache device is
not registered.  It needs the cache device metadata in order to know the
correct state of each piece of data.

That is, when you are using writeback mode, you need the cache device,
because some of the writes will go to the cache device and some to the
backing device.

Mike
