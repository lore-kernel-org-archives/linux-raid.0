From: "Daniel Zetterman" <daniel.zetterman@gmail.com>
Subject: Re: Faster read performance DURING (?) resync on raid10
Date: Sat, 27 Sep 2008 01:19:50 +0200
Message-ID: <104f2a240809261619m2512bddem11ea7960d86df2ff@mail.gmail.com>
References: <19666016.post@talk.nabble.com>
	 <18652.25227.7530.435789@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18652.25227.7530.435789@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've done some more tests and here are the results:

# bonnie++ during resync with readahead set to 512 (encrypted raid10)
kpax,4G,,,77308,21,34585,17,,,82073,33,384.8,1,,,,,,,,,,,,,
kpax,4G,,,77958,21,34810,17,,,83002,34,394.0,1,,,,,,,,,,,,,
kpax,4G,,,78273,21,34884,17,,,82758,34,389.0,1,,,,,,,,,,,,,

# bonnie++ during resync with readahead set to 65536 (encrypted raid10)
kpax,4G,,,77873,21,34927,18,,,82941,34,367.5,0,,,,,,,,,,,,,
kpax,4G,,,77072,21,34966,18,,,82234,34,357.6,1,,,,,,,,,,,,,
kpax,4G,,,78033,21,34904,18,,,83381,34,372.2,1,,,,,,,,,,,,,

As seen from above, the read throughput from bonnie++ is about  80 MiB
/s during resync, regardless of the readahead size on encrypted
raid10.

# bonnie++ after resync with readahead set to 512 (encrypted raid10)
kpax,4G,,,81619,22,31528,16,,,70996,28,411.7,1,,,,,,,,,,,,,
kpax,4G,,,81013,22,31341,15,,,68451,28,354.1,1,,,,,,,,,,,,,
kpax,4G,,,81750,22,31291,16,,,69484,28,364.5,0,,,,,,,,,,,,,

# bonnie++ after resync with readahead set to 65536 (encrypted raid10)
kpax,4G,,,81464,22,31348,16,,,69140,28,356.4,1,,,,,,,,,,,,,
kpax,4G,,,81803,22,31039,16,,,67414,27,338.6,1,,,,,,,,,,,,,
kpax,4G,,,81263,22,31361,16,,,70491,28,326.7,0,,,,,,,,,,,,,

The above tests shows that the read throughput drops 15% to about 68
MiB /s  after the resync has finished.

If I run the same set of tests without encryption, I get:

# bonnie++ during resync with readahead set to 512 (normal raid10)
kpax,4G,,,90242,24,58586,20,,,138938,34,320.0,0,,,,,,,,,,,,,
kpax,4G,,,90101,24,53133,19,,,141617,36,414.7,1,,,,,,,,,,,,,
kpax,4G,,,88971,24,53107,19,,,135751,33,437.4,1,,,,,,,,,,,,,
kpax,4G,,,89262,24,53058,19,,,134046,33,411.3,1,,,,,,,,,,,,,

# bonnie++ during resync with readahead set to 65536 (normal raid10)
kpax,4G,,,87487,24,59635,22,,,139171,30,440.3,1,,,,,,,,,,,,,
kpax,4G,,,88879,24,60615,22,,,148133,32,426.5,1,,,,,,,,,,,,,
kpax,4G,,,88836,24,56569,21,,,139867,30,423.0,1,,,,,,,,,,,,,
kpax,4G,,,89166,24,58811,22,,,134982,30,422.2,1,,,,,,,,,,,,,

Now we see that we have alot more juice without the encryption -
pumping about 136 MiB / s during read.

# bonnie++ after resync with readahead set to 512 (normal raid10)
kpax,4G,,,95747,27,45329,17,,,123298,31,546.7,1,,,,,,,,,,,,,
kpax,4G,,,94950,26,45006,16,,,128461,31,476.8,1,,,,,,,,,,,,,
kpax,4G,,,95652,26,45202,16,,,130082,32,442.7,1,,,,,,,,,,,,,
kpax,4G,,,94900,26,44224,16,,,125801,31,455.1,1,,,,,,,,,,,,,

# bonnie++ after resync with readahead set to 65536 (normal raid10)
kpax,4G,,,95475,27,71200,28,,,172074,37,429.2,1,,,,,,,,,,,,,
kpax,4G,,,94724,26,68041,26,,,162545,34,447.5,1,,,,,,,,,,,,,
kpax,4G,,,95133,27,72185,28,,,160979,35,412.8,1,,,,,,,,,,,,,
kpax,4G,,,95090,27,71043,27,,,167199,36,421.7,1,,,,,,,,,,,,,

And the grand finale - running plain raid10 with full readahead, shows
a whopping 161 MiB /s.

To summarize:
1) There seems to be something fishy going on using dm-crypt over
linux raid which makes read throughput go down after the resync is
done.
2) The readahead size does not seem to make any difference on
encrypted raid arrays.

Request:
Could someone try encryption over raid10 and run bonnie++ tests during
and after initial resync to see if we get similar results?

Does anyone have a clue to what this could be?

On Fri, Sep 26, 2008 at 6:18 AM, Neil Brown <neilb@suse.de> wrote:
>
> On Thursday September 25, daniel.zetterman@gmail.com wrote:
> >
> > I have done some automated scripted tests with bonnie++ over RAID10 and
> > encryption, using different encryption cipher modes to evaluate the impact
> > on I/O operations.
> > The strange thing is that I can see a significant increase in read
> > performance (about 20%) when running the tests DURING the raid resync phase
> > directly after the raid creation as appose to running it after the resync,
> > or after I create the array with --assume-clean (which skips initial
> > resync).
>
> Sounds like the read-balancing is doing exactly the wrong thing -
> quite possible.
>
> What layout are you using (near, far, offset?), how many devices?
>
> NeilBrown
