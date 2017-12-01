From: Michael Lyle <mlyle@lyle.org>
Subject: =?UTF-8?B?UmU6IOWbnuWkje+8muWbnuWkje+8muWbnuWkje+8mltQQVRDSF0gYmNh?=
 =?UTF-8?Q?che:_Fix_bdev_leak_during_backing_device_registering?=
Date: Thu, 30 Nov 2017 18:38:29 -0800
Message-ID: <cf2306bc-deee-17b2-1a25-eb9b31c53de7@lyle.org>
References: <fd806bd1-6537-42a7-8af3-d8dee9cb8fb9.liangyan.ply@alibaba-inc.com>
 <77a964ce-696e-4736-8dd9-c23969c7b567.liangyan.ply@alibaba-inc.com>
 <22f7350f-4251-443f-b346-9cd98d98d1ed.liangyan.ply@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <22f7350f-4251-443f-b346-9cd98d98d1ed.liangyan.ply@alibaba-inc.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: =?UTF-8?B?5b2t6Imv5b2m?= <liangyan.ply@alibaba-inc.com>, linux-bcache <linux-bcache@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Coly Li <colyli@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?5Y2V5Zu95paHKOa4oeazoik=?= <dubo.sgw@alibaba-inc.com>, =?UTF-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@alibaba-inc.com>
List-Id: linux-raid.ids

On 11/30/2017 06:30 PM, 彭良彦 wrote:
> If the cache device is not persistent like ramdisk,  all data will be lost after reboot. We have to use make-bcache to fix the inconsistent super block of backing device.N�����r��y���b�X��ǧv�^�)޺{.n�+����{�mƜ�觶��ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢfl===

Using a non-persistent writeback cache is guaranteed to lose data.
(Writes will only go to the cache device and not make it to the
persistent volume).

Mike
