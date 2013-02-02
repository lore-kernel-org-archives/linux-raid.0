From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Sat, 2 Feb 2013 13:34:04 -0700
Message-ID: <1582E753-C658-47A6-B5CE-C259954FEBEC@colorremedies.com>
References: <510A4AAE.6000009@evilazrael.de> <20130131113820.GA20536@cthulhu.home.robinhill.me.uk> <510A6E54.5050001@evilazrael.de> <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com> <20130131221007.GA1447@cthulhu.home.robinhill.me.uk> <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com> <20130201133455.GA24375@cthulhu.home.robinhill.me.uk> <9F0E4AF3-4358-425F-8078-C068D5BB9487@colorremedies.com> <20130201195734.GA16573@cthulhu.home.robinhill.me.uk> <510C5E3F.8090807@evilazrael.de> <510C6AB6.8040900@turmel.org> <510D36D7.5050704@evilazrael.de>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510D36D7.5050704@evilazrael.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>, Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Feb 2, 2013, at 8:55 AM, Christoph Nelles <evilazrael@evilazrael.de> wrote:
> 
> Am 02.02.2013 02:24, schrieb Phil Turmel:
>> 
> 
>> Your descriptions and kernel logs suggest that is /dev/sdg, but the
>> "mdadm --examine" reports show /dev/sdg was in the array longer than
>> /dev/sdj.  Please elaborate.
> 
> Where do you read that?

error1.txt and error2.txt attachments. A write error for sdg occurred three days before sdj.

From error1.txt:

Jan 28 00:23:36 router kernel: Write(16): 8a 00 00 00 00 01 36 b2 55 50 00 00 00 30 00 00
Jan 28 00:23:36 router kernel: end_request: I/O error, dev sdg, sector 5212624208

From error2.txt
Jan 31 00:34:13 router kernel: Read(16): 88 00 00 00 00 01 21 45 d3 08 00 00 04 00 00 00
Jan 31 00:34:13 router kernel: end_request: I/O error, dev sdj, sector 4853191432


Chris Murphy

