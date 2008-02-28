From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: 2x6 or 3x4 raid10 arrays ?
Date: Thu, 28 Feb 2008 19:25:00 +0100
Message-ID: <20080228192500.4d9110d9@absurd>
References: <1204195554.16924.16.camel@franck-gusty>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1204195554.16924.16.camel@franck-gusty>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Franck Routier said:     (by the date of Thu, 28 Feb 2008 11:45:54 +0100)

> Hi,
> 
> I am installing a database (postgresql) server.
> I am considering two options:
> - either setup two 6 disks raid10 arrays
> - or setup three 4 disks raid10 arrays
> 
> You guessed I have 12 disks :)

wouldn't be a single raid10 far=2, the fastest solution? But you get
only half of the capacity.

-- 
Janek Kozicki                                                         |
