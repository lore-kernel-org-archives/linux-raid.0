From: Christian Nilsson <nikize@gmail.com>
Subject: Re: Reshape/Grow to fewer but bigger devices
Date: Wed, 31 Jul 2013 01:33:46 +0200
Message-ID: <CAHhAHvhek+ObrM3drgyfs3EH6itoyB2WjxkBK2TcmORw0N_STQ@mail.gmail.com>
References: <CAHhAHviuST+LXb36-XOz+UtZiFv0j8AX+iZ0_gS2MCWZaYhiQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHhAHviuST+LXb36-XOz+UtZiFv0j8AX+iZ0_gS2MCWZaYhiQg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have tried to find an answer, but my "search fu powers" are now
coming to a end.
What i want to do was more or less detailed by Neil in
http://marc.info/?l=linux-raid&m=129785210102555
the section titled "When reshaping an array to fewer devices, allow
'size' to be increased"

but just to explain:
I have a 9 devices in a RAID5
6 of these are now 2TB disks (I really love hot replace!)
while the other 3 are still 1TB disks

I would now like to grow the array to 6x2TB instead of the present 9x1TB.

Is this possible and I just can't find how, or have there just been to
many other great features instead?
(I have started a ext4 offline shrink.. but it is a real pain.)

/Christian
