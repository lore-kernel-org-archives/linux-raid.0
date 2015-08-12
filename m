From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: Rebuilding array
Date: Wed, 12 Aug 2015 20:39:09 +0200
Message-ID: <55CB92CD.3020409@gmail.com>
References: <723CC011-48A8-4BF7-B6F7-8C847E6F72BA@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <723CC011-48A8-4BF7-B6F7-8C847E6F72BA@me.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/08/15 18:58, Hans Malissa wrote:
> Can a RAID1 array be used/mounted while it=92s rebuilding?

Yes.

But don't take my word for it: you can test it by setting up a test
array on a couple of loop devices and play around with
failing/removing/adding components to it while the array is mounted. Of
course you need to have at least one active device that's fully in sync
at all times.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
