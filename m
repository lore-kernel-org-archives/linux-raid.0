From: Luca Berra <bluca@comedia.it>
Subject: Re: Mdadm, udev and fakeraid?
Date: Sat, 16 Apr 2011 07:27:59 +0200
Message-ID: <20110416052758.GA14255@maude.comedia.it>
References: <BANLkTinp3376PV3sJWARXtFnRfoMsg44wA@mail.gmail.com> <20110405162008.5f2c48fe@notabene.brown> <BANLkTik+xU6K7B9Xomj6+Q-S7_n18+aQqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTik+xU6K7B9Xomj6+Q-S7_n18+aQqA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 15, 2011 at 04:15:50PM +0200, Seblu wrote:
>To test this kind of raid, i created a dmraid array in a vm. This
                                                      ^^^^^^^^^^
>created me a /dev/mapper/isw_bfbjdbadhb_testF device.
....

>About outputs:
>mdadm -I --verbose /dev/sde
>mdadm: no RAID superblock on /dev/sde.

mdadm checks if there is an Intel Matrix controller before checking for
intel raid superblocks. On your vm you don't have an intel raid
controller.
override with environment variable IMSM_NO_PLATFORM

....
>Do not you think that dmraid should also ship an udev rules file to
>mount the raid which can handle?
NO

-- 
Luca Berra -- bluca@comedia.it
