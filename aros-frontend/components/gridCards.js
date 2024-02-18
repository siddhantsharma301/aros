export default function GridCards(props) {
    return (
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
        {props.pubKeys.map((pubKey) => (
          <div
            key={pubKey.userId}
            className="relative flex items-center space-x-3 rounded-lg border border-gray-300 bg-white px-6 py-5 shadow-sm focus-within:ring-2 focus-within:ring-indigo-500 focus-within:ring-offset-2 hover:border-gray-400"
          >
            <div className="min-w-0 flex-1">
              <a href="#" className="focus:outline-none">
                <span className="absolute inset-0" aria-hidden="true" />
                <p className="text-lg text-gray-900 font-bold">
                {pubKey.userId}
                </p>
                <div className="mb-1"></div>
                <p className="truncate text-sm text-gray-900">
                <span className="text-blue-500">Public key: </span>{pubKey.pubKey}
                </p>
              </a>
            </div>
          </div>
        ))}
      </div>
    )
  }
  