From: Michael Lyle <mlyle@lyle.org>
Subject: =?UTF-8?B?UmU6IOWbnuWkje+8muWbnuWkje+8muWbnuWkje+8muWbnuWkje+8mltQ?=
 =?UTF-8?Q?ATCH]_bcache:_Fix_bdev_leak_during_backing_device_registering?=
Date: Thu, 30 Nov 2017 20:25:02 -0800
Message-ID: <963775f5-a0e1-e727-defe-c123ae299028@lyle.org>
References: <fd806bd1-6537-42a7-8af3-d8dee9cb8fb9.liangyan.ply@alibaba-inc.com>
 <77a964ce-696e-4736-8dd9-c23969c7b567.liangyan.ply@alibaba-inc.com>
 <22f7350f-4251-443f-b346-9cd98d98d1ed.liangyan.ply@alibaba-inc.com>
 <86da49cd-a506-4fd7-8b8e-5d142106a007.liangyan.ply@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <86da49cd-a506-4fd7-8b8e-5d142106a007.liangyan.ply@alibaba-inc.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: =?UTF-8?B?5b2t6Imv5b2m?= <liangyan.ply@alibaba-inc.com>, linux-bcache <linux-bcache@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Coly Li <colyli@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?5Y2V5Zu95paHKOa4oeazoik=?= <dubo.sgw@alibaba-inc.com>, =?UTF-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@alibaba-inc.com>
List-Id: linux-raid.ids

On 11/30/2017 07:38 PM, 彭良彦 wrote:
> On 17/12/1 上午10:38, Michael Lyle wrote:
>> On 11/30/2017 06:30 PM, 彭良彦 wrote:
>>> If the cache device is not persistent like ramdisk,  all data will be lost after reboot. We have to use make-bcache to fix the inconsistent super block of backing device.
>>
>> Using a non-persistent writeback cache is guaranteed to lose data.
>> (Writes will only go to the cache device and not make it to the
>> persistent volume).
>>
>> Mike
> 
> If we use ramdisk as a writethrough cache to improve the read performance, the backing device is a network disk, the super block state of backing device still has chance to be inconsistent due to disconnected network. Like in above reproduce steps, i didn't use a cache device. :-)N�����r��y���b�X��ǧv�^�)޺{.n�+����{�mƜ�觶��ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢfl===
> 

I cannot accept this patch.  It is guaranteed to corrupt data, by
starting the client device when the cache is in a bad state.

If you use 'writeback', you must have a cache device and the cache
device must be present to start the bcache client device.

Mike
