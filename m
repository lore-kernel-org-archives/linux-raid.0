From: Light King <thelightking@gmail.com>
Subject: Doubt
Date: Thu, 5 Nov 2009 12:56:30 +0530
Message-ID: <d3540f4d0911042326o754d5f06qf958d8ab5b309e86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i have four cf card and i have one pci based cf card
contoller(addonics card with pata_sil6800 driver).when i am connecting
this four cf card to addonics card(which has four slots for cf cards)
and inserting this total hardware package to pci slot of pc in linux
os it is showing four different block devices to me.So using mdadm
2.6.3 software raid i am creating a raid device of level 0 . If one cf
card from this hardware package getting failed the raid-device is
becoming inactive .If i am trying to reactive the raid device using
mdamd -R command it is giving a error of "memory cannot be allocated
for the raid device " .The same thing i am trying with raid10 (our
hardware only supports raid=A0 level 0 ,1,10) and if one cf card got
failed we are abel to reactive the raid device.But=A0 the issue we are
facing in raid10 is it is taking 50%(2-CF card out of 4) of total
memory space as mirroring which is a loss for us .

So we dont want any kind of data recovery in our raid device (like
raid0) but we want if one cf card failed also, the raid device should
run or should reactive without any error(like raid10) but we should
abel to use the total disk space (like raid0).

or

any idea to increase size of storage memory created by raid10 (50% is
going waste due to mirroring and our hardware doesnot support raid5) .



How we are simulating=A0 a cf card fail?
answer: according to raid document=A0 "
http://tldp.org/HOWTO/Software-RAID-HOWTO-6.html " if we switch of the
system and remove a cf card ,it will simulate a disk failure .

Please provid any help to me i will be kind of you.
thanking you for your genuine support

ANSH
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
