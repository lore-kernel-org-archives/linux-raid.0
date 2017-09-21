From: Phil Turmel <philip@turmel.org>
Subject: Re: Data recovery
Date: Thu, 21 Sep 2017 08:10:07 -0400
Message-ID: <796e5efe-04af-60c7-4ef0-f9962e456061@turmel.org>
References: <CAEmSg0_=5ni2mA1Q_A1DjZmvjG9u8tKXOQHmnmT33=12yJwYqA@mail.gmail.com>
 <59C309C7.9030300@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59C309C7.9030300@youngman.org.uk>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, =?UTF-8?B?Vm9qdMSbY2ggS2xldGXEjWth?= <vojta.kletecka@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/20/2017 08:37 PM, Wols Lists wrote:
> On 21/09/17 01:08, Vojtěch Kletečka wrote:

> Thank $DEITY for that - do NOT use --create - at least don't use it if
> you want to recover your data !!!

Yes, do NOT use --create.

>> Thank you for your time and any suggestions.
>>
> Get a SATA add in card if you don't have enough SATA ports, and get rid
> of USB !!!

After you reassemble one more time and finish backing up.

> I'll let others chime in on how to get your array back - IF you put the
> drives on SATA, I hope it's just a simple "--assemble --force" which
> will result in everything sorting itself out, but we'll see. But don't
> put USB drives into a raid array!

Please run and report the output of the following commands:

for x in /dev/sd[cde] ; do echo $x ; smartctl -iA -l scterc $x ; done

for x in /sys/block/sd[cde]/device/timeout ; do echo $x $(< $x) ; done

You may have problems that will interfere with rebuilding onto sdd1.

After we see the above, you will be asked to do this:

mdadm --assemble --force --verbose /dev/md127 /dev/sd[cde]1

If this doesn't work (I'll be shocked), please post what it prints.

Phil
