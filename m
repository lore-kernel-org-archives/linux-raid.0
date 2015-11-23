From: Semyon Enskiy <semyon.enskiy@yandex.ru>
Subject: Re: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Mon, 23 Nov 2015 18:35:44 +0300
Message-ID: <2542241448292944@web16h.yandex.ru>
References: <189791448292518@web28m.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <189791448292518@web28m.yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

/
Seems, that I should write data back to source block device to do it
consistent and able to recreate array with one corrupted device, reboot,
recreate array, resync faulty device.
/
