From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Cry for help before I screw up a raid recovery more...
Date: Tue, 22 Apr 2014 19:49:08 +0800
Message-ID: <53565734.5020706@fnarfbargle.com>
References: <53561841.3060907@csun.edu> <535621B9.90003@shaw.ca> <53562482.5010200@csun.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53562482.5010200@csun.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Wiegley <jeffw@csun.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/04/14 16:12, Jeff Wiegley wrote:

> Though... on a positive note: I did find backups of my luks headers.
> I did: cryptsetup --header nas.luks luksOpen /dev/md3 md3
> and it dutifully asks me for a passphrase AND accepts the passphase.
> however, mounting the XFS filesystem that use to be there... doesn't
> work. which I think is REALLY weird. the encryption keys are there
> and recognized which should indicate a pretty good level of data
> integrity but the filesystem under the encryption seems non-existant.

Like a filesystem superblock, your LUKS header probably fits neatly well 
within a single chunk, so provided that particular disk was in the right 
position in the array, it'd quite happily try and open it up. 
Unfortunately if the other drives are not quite right it will just fail 
to find the filesystem inside the container, or worse..

I don't consider everything to be right until it'll pass a fsck -n.


