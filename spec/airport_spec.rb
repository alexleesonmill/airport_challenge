require_relative '../lib/airport'
require_relative '../lib/plane'

describe Airport do
  let(:plane) { double :plane }
  it { is_expected.to respond_to(:land).with(1).argument }
  it { is_expected.to respond_to(:takeoff) }

  it 'lands a plane at the airport' do
    plane = Plane.new
    allow(subject).to receive(:stormy?).and_return(false)
    expect(subject.land(plane)).to eq [plane]
  end

  it 'instructs a plane to take off from the airport' do
    plane = Plane.new
    allow(subject).to receive(:stormy?).and_return(false)
    subject.land(plane)
    expect(subject.takeoff(plane)).to eq plane
  end

  it 'checks that the plane has taken off' do
    plane = Plane.new
    allow(subject).to receive(:stormy?).and_return(false)
    subject.land(plane)
    length = subject.planes.length
    subject.takeoff(plane)
    expect(length).to eq(subject.planes.length + 1)
  end

  it 'defaults to a specified capacity' do
    expect(subject.capacity).to eq(1)
  end

  it 'allows the airport capacity to be overridden' do
    airport = Airport.new(20)
    expect(airport.capacity).not_to eq 1
  end

  it 'stops a plane from landing if airport is full' do
    plane = Plane.new
    allow(subject).to receive(:stormy?).and_return(false)
    allow(plane).to receive(:already_landed?).and_return(false)
    subject.capacity.times { subject.land plane }
    expect { subject.land plane }.to raise_error 'Airport Full'
  end

  it 'does not allow take off due to stormy weather' do
    allow(subject).to receive(:stormy?).and_return(true)
    expect { subject.takeoff(plane) }.to raise_error 'Too Stormy to take off'
  end

  it 'does not allow land due to stormy weather' do
    allow(plane).to receive(:already_landed?).and_return(false)
    allow(subject).to receive(:stormy?).and_return(true)
    expect { subject.land(plane) }.to raise_error 'Too Stormy to land'
  end
end
