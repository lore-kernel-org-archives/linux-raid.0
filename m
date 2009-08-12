From: Billy Crook <billycrook@gmail.com>
Subject: Re: max number of devices in raid6 array
Date: Wed, 12 Aug 2009 11:27:51 -0500
Message-ID: <a43edf1b0908120927g2ef949f8gb660be10cf3d6249@mail.gmail.com>
References: <20090812090600.GF21118@nfs-rbx.ovh.net> <55226.78.86.108.203.1250069920.squirrel@www.yuiop.co.uk>
	<20090812121911.GG21118@nfs-rbx.ovh.net> <87ab259j8m.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ab259j8m.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: David Cure <lnk@cure.nom.fr>, John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 12, 2009 at 09:53, Goswin von Brederlow<goswin-v-b@web.de> wrote:
> With how many devices does the MTBFS of
> a raid6 drop below that of a single disk?

Four devices.

The more important thing to worry about is running in to an
uncorrectable error during rebuild, twice during the same rebuild.
I'd say a good rule of thumb is no more than 8TB in a RAID5 array;
16TB in a raid6 array if you want to remain very safe.  YMMV.  Your
risk comfort and willingness to restore from backups will vary as
well.
