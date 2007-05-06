From: Benjamin Davenport <linux-raid-reg@monkeysushi.net>
Subject: Re: Speed variation depending on disk position
Date: Sun, 06 May 2007 00:02:16 -0500
Message-ID: <463D6158.7030807@monkeysushi.net>
References: <Pine.LNX.4.64.0705051228300.12744@p34.internal.lan> <20070505205456.GA17112@tuatara.stupidest.org> <463CF908.6000602@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463CF908.6000602@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Is the behavior you are describing above [decaying STR]
> manufacturer dependent or it is pretty much dictated by the general
> design of modern drives?

It's an artifact of the physical layout of the disk.  Disks are divided into
tracks (concentric circles laid out across the surface of the drive).  Clearly,
the outer tracks are longer than the inner tracks.  For a very long time, drives
have therefore stored more information on these outer tracks.  Since the disk's
spindle speed is constant, reading these outer tracks therefore means more data
passes under the active read head in a given second.  That's why you see
sequential transfer rates decay from the start (outer tracks) of the disk to the
end (inner tracks).  This is the opposite of the behavior seen on CDs, because
the start of a CD is the inside track.

-Ben
