From: =?UTF-8?B?0J/RkdGC0YAg0JEu?= <satnatantas@gmail.com>
Subject: Re: ICH RAID5 delisted and broken after mdadm installation
Date: Mon, 18 Jan 2016 20:13:15 +0300
Message-ID: <CA+Ni7jM-Ad4G=_23uL9K-4Ya46K2NV-0LqnaaQW7fR4+npMPXA@mail.gmail.com>
References: <CA+Ni7jMa2TSSYbDcZ-HQTp5O42UZ==r7wJ5dikXfytHgHF7pzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+Ni7jMa2TSSYbDcZ-HQTp5O42UZ==r7wJ5dikXfytHgHF7pzQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I found a mistake: sdc contains Windows and is failing, not sdb.
